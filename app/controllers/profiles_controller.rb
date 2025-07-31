class ProfilesController < ApplicationController
  # before_action :set_profile, only: %i[ show edit update destroy ]

  # GET /profiles or /profiles.json
  def index
    @profiles = Profile.all
  end

  def show
    if current_user&.id == params[:id].to_i
      # redirect to my profile
      redirect_to index_user_photos_path(current_user)
    else
      redirect_to profile_photos_path(params[:id])
    end
  end

  def new
    @profile = Profile.new
  end

  def edit
  end

  def create
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: "Profile was successfully created." }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1 or /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: "Profile was successfully updated." }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @profile.destroy!

    respond_to do |format|
      format.html { redirect_to profiles_path, status: :see_other, notice: "Profile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Show all followers of a profile (public mode)
  def index_followers
    @target_profile = Profile.find(params[:profile_id])
    @target_person = @target_profile.user
    @followers = Follow.where(followee_id: @target_profile.user_id).pluck(:follower_id)
    @follower_profiles = Profile.where(user_id: @followers)
    @is_public = true
    # @is_following = check_follow(current_user.profile, @target_profile)
    render "profiles/show"
  end

  # Show all followers of a profile (public mode)
  def index_followings
    @target_profile = Profile.find(params[:profile_id])
    @target_person = @target_profile.user
    @followings = Follow.where(follower_id: @target_profile.user_id).pluck(:followee_id)
    @following_profiles = Profile.where(user_id: @followings)
    @is_public = true
    # @is_following = check_follow(current_user.profile, @target_profile)
    render "profiles/show"
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.expect(profile: [ :photos_count, :albums_count, :followers_count, :followings_count ])
    end

    def check_follow(person1, person2)
      Follow.exists?(follower_id: person1.user_id, followee_id: person2.user_id)
    end
end
