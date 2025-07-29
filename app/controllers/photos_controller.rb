class PhotosController < ApplicationController
    before_action :require_login!, except: [ :index, :show ]
    before_action :check_private, only: [ :show ]
    before_action :set_photo, only: %i[ show edit update destroy ]
    before_action -> { require_owner!(@photo) }, except: [ :index, :show ]

  # GET /photos or /photos.json
  def index
    # Show all public photos in guest mode
    @posts = Photo.all.includes(profile: :user).where(is_public: true).order(updated_at: :desc)
    @is_photo = true # to render photo partial
  end

  def index_feeds
    # TODO: Show all photos in of people who u are following
    following_ids = Follow.where(follower_id: current_user.id).pluck(:followee_id)
    @photos = Photo.where(user_id: following_ids).includes(:profile).order(updated_at: :desc)

    render :index
  end

def index_discover
    # Show all photos of people you are not following
    following_ids = Follow.where(follower_id: current_user.id).pluck(:followee_id)
    @photos = Photo.where.not(user_id: following_ids).includes(:profile).order(updated_at: :desc)

    render :index
end

  def index_user
    # TODO: show all photos in your own profile (only u can view)
    @target_person = Profile.find(current_user.id)
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
      puts "Submitted params: #{params.inspect}"
      @photo = current_user.profile.photos.build(photo_params)
      if @photo.save
        redirect_to index_user_photos_path(current_user), notice: "Photo is successfully created."
      else
        flash.now[:alert] = "Photo could not be created. Please check the errors below."
        render :new, status: :unprocessable_entity
      end
  end

  # PATCH/PUT /photos/1 or /photos/1.json
  def update
      if @photo.update(photo_params)
        redirect_to index_user_photos_path(current_user), notice: "Photo was successfully updated!"
      else
        redirect_to new_user_photos_path(current_user), alert: "Fail to update!."
      end
  end

  # DELETE /photos/1 or /photos/1.json
  def destroy
    @photo.destroy!

    respond_to do |format|
      format.html { redirect_to photos_path, status: :see_other, notice: "Photo was successfully destroyed." }
      format.json { head :no_content }
    end
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
