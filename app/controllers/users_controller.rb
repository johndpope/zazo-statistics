class UsersController < AdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :visualization,
                                  :new_connection, :establish_connection,
                                  :receive_test_video, :receive_corrupt_video,
                                  :events]
  decorates_assigned :user

  # GET /users
  # GET /users.json
  def index
    term = params[:user_id_or_mkey]
    if term.present?
      user = if term =~ /^\d+$/i
                User.find(term.to_i)
             else
                User.find_by_mkey(term)
             end
      if user.present?
        redirect_to(user)
      else
        flash[:alert] = t('messages.user_not_found', query: params[:user_id_or_mkey])
      end
    end
    @users = User.search(params[:query]).page(params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @message_statuses = if @user.connected_users.count > 1
      events_api.metric_data(:messages_statuses_between_users,
                             user_id: @user.event_id,
                             friend_ids: @user.connected_users.map(&:event_id))
                        else
                          {}
                        end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # GET /users/new_connection/1
  def new_connection
    @users = User.all - [@user] - @user.connected_users
  end

  def establish_connection
    respond_to do |format|
      connection = Connection.find_or_create(@user.id, params[:target_id])
      if connection
        connection.establish! if connection.may_establish?
        format.html { redirect_to @user, notice: 'Connection was successfully created.' }
      else
        format.html { redirect_to @user, notice: 'Connection could not be created.' }
      end
    end
  end

  # Send test_video
  def receive_test_video
    receive_video Rails.root.join('test_video.mp4')
  end

  def receive_corrupt_video
    receive_video Rails.root.join('app/assets/images/orange-background.jpg')
  end

  def events
    @user.events = events_api.filter_by(@user.event_id, reverse: true)
    @user.events.map! { |e| Event.new(e) }
  end

  def visualization
    allowed = UserVisualizationDataQuery::ALLOWED_SETTINGS
    @settings = allowed.each_with_object({}) do |attr, memo|
      memo[attr] = params[attr]
    end
  end

  private

  def receive_video(file_name)
    sender = User.find params[:sender_id]
    video_id = create_test_video(sender, @user, file_name)
    Kvstore.add_id_key(sender, @user, video_id)
    @push_user = PushUser.find_by_mkey(@user.mkey) || not_found
    send_video_received_notification(@push_user, sender.mkey, sender.first_name, video_id)
    redirect_to @user, notice: "Video sent from #{sender.first_name} to #{@user.first_name}."
  end

  def test_video_id
    (Time.now.to_f * 1000).to_i.to_s
  end

  def create_test_video(sender, receiver, file_name)
    video_id = test_video_id
    put_s3_object(sender, receiver, video_id, file_name)
    video_id
  end

  def put_s3_object(sender, receiver, video_id, file_name)
    cred = S3Credential.instance
    cred.s3_client.put_object(bucket: cred.bucket,
                              key: Kvstore.video_filename(sender, receiver, video_id),
                              body: File.read(file_name))
  end

  def test_video
    Video.find_by_filename 'test_video'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :mobile_number, :device_platform, :auth, :mkey, :status)
  end
end
