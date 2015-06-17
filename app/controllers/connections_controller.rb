class ConnectionsController < AdminController
  before_action :set_connection, only: [:show, :edit, :update, :destroy, :messages]

  # GET /connections
  # GET /connections.json
  def index
    @connections = Connection.all.page(params[:page])
  end

  # GET /connections/1
  # GET /connections/1.json
  def show
    @aggregate_messaging_info = events_api.metric_data(:aggregate_messaging_info,
                                                      user_id: @connection.creator.event_id,
                                                      friend_id: @connection.target.event_id)
  end

  # GET /connections/new
  def new
    @connection = Connection.new
  end

  # GET /connections/1/edit
  def edit
  end

  # POST /connections
  # POST /connections.json
  def create
    @connection = Connection.new(connection_params)

    respond_to do |format|
      if @connection.save
        format.html { redirect_to @connection, notice: 'Connection was successfully created.' }
        format.json { render action: 'show', status: :created, location: @connection }
      else
        format.html { render action: 'new' }
        format.json { render json: @connection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /connections/1
  # PATCH/PUT /connections/1.json
  def update
    respond_to do |format|
      if @connection.update(connection_params)
        format.html { redirect_to @connection, notice: 'Connection was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @connection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /connections/1
  # DELETE /connections/1.json
  def destroy
    @connection.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def messages
    @creator_to_target_messages = events_api.messages(
      sender_id: @connection.creator.event_id,
      receiver_id: @connection.target.event_id,
      reverse: true).map { |m| Message.new(m) }
    @creator_to_target_messages = MessageDecorator.decorate_collection(@creator_to_target_messages)
    @target_to_creator_messages = events_api.messages(
      sender_id: @connection.target.event_id,
      receiver_id: @connection.creator.event_id,
      reverse: true).map { |m| Message.new(m) }
    @target_to_creator_messages = MessageDecorator.decorate_collection(@target_to_creator_messages)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_connection
    @connection = Connection.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def connection_params
    params.require(:connection).permit(:creator_id, :target_id, :status)
  end
end
