class PhotosController < ApplicationController
    before_action :require_login!, except: [ :index, :show, :redirect_root, :index_profile ]
    before_action :check_private, only: [ :show ]
    before_action :set_photo, only: %i[ show edit update destroy ]
    before_action -> { require_owner!(@photo) }, except: [ :index, :show, :redirect_root, :index_profile ]

  # Redirect root to show all posts of photos in guest mode
  def redirect_root
    if user_signed_in?
      if current_user.is_admin
        redirect_to admin_users_path
      else
        redirect_to user_tab_photos_path(current_user, "feeds")
      end
    else
      redirect_to guest_photos_path
    end
  end

  def index
    # Show all public photos in guest mode
    unless user_signed_in?
      @posts = Photo.all.includes(profile: :user).where(is_public: true).order(updated_at: :desc)
      render template: "layouts/post/index", locals: { title: "Photos", is_photo: true }
    else
      # If logged in, redirect to feeds
    end
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
    # TODO: Show all public photos in of people who u are following
    following_ids = Follow.where(follower_id: current_user.id).pluck(:followee_id)
    @posts = Photo.where(user_id: following_ids, is_public: true).includes(:profile).order(updated_at: :desc)
    puts "Feed post count: #{@posts.size}"
    render template: "layouts/post/index", locals: { title: "Photos", is_photo: true }
  end

  def index_discover
      # Show all public photos of people you are not following (not u too)
      following_ids = Follow.where(follower_id: current_user.id).pluck(:followee_id).push(current_user.id)
      @posts = Photo.where.not(user_id: following_ids).where(is_public: true).includes(:profile).order(updated_at: :desc)
      puts "Discover post count: #{@posts.size}"

      render template: "layouts/post/index", locals: { title: "Photos", is_photo: true }
  end

  def index_user
    # TODO: show all photos in your own profile (only u can view)
    @target_profile = current_user.profile
    @target_person = current_user
    @photos = @target_profile.photos.order(updated_at: :desc)
    @is_public = false
    render template: "profiles/show"
  end

def index_profile
    # TODO: show all of his public photos when visiting a user profile
    @target_person = User.find_by(id: params[:profile_id])
    @target_profile = @target_person.profile
    @photos = @target_profile.photos.where(is_public: true).order(updated_at: :desc)
    @is_public = true
    render template: "profiles/show"
end

  def show
  end

  def new
    @photo = Photo.new
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  def create
      # puts "Submitted params: #{params.inspect}"
      if params[:photo][:image_path].blank?
        flash[:alert] = t("message.select_img")
        redirect_to new_user_photo_path(current_user)
        return
      end

      @photo = current_user.profile.photos.build(photo_params)
      if @photo.save
        redirect_to index_user_photos_path(current_user), notice: t("message.photo_created")
      else
        flash.now[:alert] = t("message.photo_created_failed")
        render :new, status: :unprocessable_entity
      end
  end

  # PATCH/PUT /photos/1 or /photos/1.json
  def update
      if @photo.update(photo_params)
        redirect_to index_user_photos_path(current_user), notice: t("message.photo_updated")
      else
        flash.now[:alert] = t("message.photo_updated_failed")
        render :edit, status: :unprocessable_entity
      end
  end

  # DELETE /photos/1 or /photos/1.json
  def destroy
    if @photo.destroy
      removed_count = remove_empty_albums # returns how many were removed
      flash[:notice] = t("message.photo_deleted")
      if removed_count > 0
        flash[:notice] += "<br>#{removed_count} empty album#{'s' if removed_count > 1} removed."
      end
      redirect_to index_user_photos_path(current_user)
    else
        flash.now[:alert] = t("message.photo_deleted_failed")
        render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_photo
      @photo = Photo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def photo_params
      params.require(:photo).permit(:image_path, :title, :description, :is_public)
    end

    def check_private
      @photo = Photo.find(params[:id])
      unless @photo.is_public || current_user&.is_admin
        if !user_signed_in? || @photo.profile.user_id != current_user.id
          redirect_to root_path, alert: "This photo is private and cannot be viewed."
        end
      end
    end

    def remove_empty_albums
      @empty_albums = current_user.profile.albums.where(photos_count: 0)
      count = @empty_albums.count
      @empty_albums.destroy_all if @empty_albums.any?
      count
    end
end
