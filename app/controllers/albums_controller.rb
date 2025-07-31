class AlbumsController < ApplicationController
    before_action :require_login!, except: [ :index, :show, :index_profile ]
    before_action :check_private, only: [ :show ]
    before_action :set_album, only: %i[ show edit update destroy ]
    before_action -> { require_owner!(@photo) }, except: [ :index, :show, :index_profile ]

  # Redirect root to show all posts of albums in guest mode

  # GET /albums or /albums.json
  def redirect_root
    redirect_to guest_albums_path
  end

  def index
      # Show all public albums in guest mode
      @posts = Album.all.includes(:photos, profile: :user).where(is_public: true).order(updated_at: :desc)
      render template: "layouts/post/index", locals: { title: "Albums", is_photo: false }
  end

  # Redirect to feeds/discover based on params[:tab]
  def index_tab
    case params[:tab]
    when "feeds"
      index_feeds
    when "discover"
      index_discover
    else
      render file: Rails.root.join("public/404.html"), status: :not_found, layout: false
    end
  end

  def index_feeds
    # TODO: Show all public albums of people who u are following
    following_ids = Follow.where(follower_id: current_user.id).pluck(:followee_id)
    @posts = Album.where(user_id: following_ids, is_public: true).includes(:profile).order(updated_at: :desc)
    render template: "layouts/post/index", locals: { title: "Albums", is_photo: false }
  end

  def index_discover
      # Show all public albums of people you are not following
      following_ids = Follow.where(follower_id: current_user.id).pluck(:followee_id).push(current_user.id)
      @posts = Album.where.not(user_id: following_ids).where(is_public: true).includes(:profile).order(updated_at: :desc)
      render template: "layouts/post/index", locals: { title: "Albums", is_photo: false }
  end

  def index_user
    # TODO: show all albums in your own profile (only u can view)
    @target_person = current_user
    @target_profile = @target_person.profile
    @albums = @target_profile.albums.order(updated_at: :desc)
    @is_public = false
    render template: "profiles/show"
  end

def index_profile
    # TODO: show all of his public albums when visiting a user profile
    @target_person = User.find_by(id: params[:profile_id])
    @target_profile = @target_person.profile
    @albums = @target_profile.albums.where(is_public: true).order(updated_at: :desc)
    @is_public = true
    render template: "profiles/show"
end


  # GET /albums/1 or /albums/1.json
  def show
  end

  # GET /albums/new
  def new
    @album = Album.new
  end

  # GET /albums/1/edit
  def edit
  end

  # POST /albums or /albums.json
  def create
    @album = Album.new(album_params)
    @album.profile = current_user.profile

    if params[:album][:image_path].present?
      # remove nil file as Rails auto insert at multiple-file field
      files = params[:album][:image_path].reject { |f| f.blank? }

      if files.empty?
        flash.now[:alert] = t("message.upload_1_photo")
        render :new, status: :unprocessable_entity
        return
      end

      # Save album first to get its ID
      if @album.save
        files.each do |uploaded_file|
          photo = Photo.create!(
            title: @album.title, # or set a default/blank title
            description: @album.description, # or blank
            image_path: uploaded_file,
            is_public: @album.is_public,
            user_id: current_user.id
          )
          AlbumComponent.create!(album: @album, photo: photo)
        end
        redirect_to index_user_albums_path(current_user), notice: t("message.album_created")
      else
        render :new, status: :unprocessable_entity, alert: t("message.album_created_failed")
      end
    end
  end

  def update
      @album.update(album_params)
      if @album.update(album_params)
        # Update photos if any
        files = params[:album][:image_path].reject { |f| f.blank? }
        if files.any?
          # Remove existing photos and add new ones
          @album.album_components.destroy_all
          files.each do |uploaded_file|
            photo = Photo.create!(
              title: @album.title, # or set a default/blank title
              description: @album.description, # or blank
              image_path: uploaded_file,
              is_public: @album.is_public,
              user_id: current_user.id
            )
            AlbumComponent.create!(album: @album, photo: photo)
          end
        end
        redirect_to index_user_albums_path(current_user), notice: t("message.album_updated")
      else
        render :edit, status: :unprocessable_entity, alert: t("message.album_updated_failed")
      end
  end

  def destroy
    if @album.destroy
      redirect_to index_user_albums_path(current_user), notice: t("message.album_deleted")
    else
      render :edit, status: :unprocessable_entity, alert: t("message.album_deleted_failed")
    end
  end

  private
    def set_album
      @album = Album.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def album_params
       params.require(:album).permit(:title, :description, :is_public)
    end

    def check_private
      @album = Album.find(params[:id])
      unless @album.is_public
        if !user_signed_in? || @album.profile.user_id != current_user.id
          redirect_to root_path, alert: "This album is private and cannot be viewed."
        end
      end
    end
end
