class PhotosController < ApplicationController
    before_action :require_login!, except: [ :index, :show ]
    before_action :check_private, only: [ :show ]
    before_action :set_photo, only: %i[ show edit update destroy ]
    before_action -> { require_owner!(@photo) }, except: [ :index, :show ]

  # GET /photos or /photos.json
  def index
    # Show all public photos in guest mode
    unless user_signed_in?
    @posts = Photo.all.includes(profile: :user).where(is_public: true).order(updated_at: :desc)
    @is_photo = true # to render photo partial
    else
      # If logged in, redirect to feeds
      redirect_to user_tab_photos_path(current_user, "feeds")
    end
  end

  def index_feeds
    # TODO: Show all photos in of people who u are following
    following_ids = Follow.where(follower_id: current_user.id).pluck(:followee_id)
    @posts = Photo.where(user_id: following_ids).includes(:profile).order(updated_at: :desc)
    @is_photo = true
    render :index
  end

def index_discover
    # Show all photos of people you are not following
    following_ids = Follow.where(follower_id: current_user.id).pluck(:followee_id)
    @posts = Photo.where.not(user_id: following_ids).includes(:profile).order(updated_at: :desc)
    @is_photo = true
    render :index
end

  def index_user
    # TODO: show all photos in your own profile (only u can view)
    @target_person = current_user.profile
    @photos = @target_person.photos.order(updated_at: :desc)
    @is_public = false
    render template: "profiles/show"
  end

def index_profile
    # TODO: show all of his public photos when visiting a user profile
    @photos = Photo.where(user_id: params[:profile_id], is_public: true).order(updated_at: :desc)
    @is_public = true
    @target_person = Profile.find_by(user_id: params[:profile_id])
    render template: "profiles/show"
end

  # GET /photos/1 or /photos/1.json
  def show
    # @photo = Photo.find(params[:id])
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos or /photos.json
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
    @photo.destroy!

      format.html { redirect_to photos_path, status: :see_other, notice: t("message.photo_deleted") }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def photo_params
      params.require(:photo).permit(:image_path, :title, :description, :is_public)
    end

    def check_private
      @photo = Photo.find(params[:id])
      unless @photo.is_public
        if !user_signed_in? || @photo.profile.user_id != current_user.id
          redirect_to root_path, alert: "This photo is private and cannot be viewed."
        end
      end
    end
end
