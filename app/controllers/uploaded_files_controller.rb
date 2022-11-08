require 'csv'

class UploadedFilesController < ApplicationController
  before_action :set_uploaded_file, only: %i[ show edit update destroy ]

  # def uploaded_file_params
  #   # params.require(uploaded_file: [:image], :commit, :authenticity_token)
  #   # params.require(:uploaded_file).permit(:source_csv_file, :commit)
  #   params.require(:uploaded_file).permit!
  # end


  # GET /uploaded_files or /uploaded_files.json
  def index
    @uploaded_files = UploadedFile.all
  end

  # GET /uploaded_files/1 or /uploaded_files/1.json
  def show
  end

  # GET /uploaded_files/new
  def new
    @uploaded_file = UploadedFile.new
  end

  # GET /uploaded_files/1/edit
  def edit
  end

  # POST /uploaded_files or /uploaded_files.json
  def create
    uploaded_file_params.permit!

    blob = ActiveStorage::Blob.create_and_upload!(
      io: uploaded_file_params[:source_csv_file],
      filename: uploaded_file_params[:source_csv_file].original_filename,
      content_type: uploaded_file_params[:source_csv_file].content_type
    )

    table = CSV.parse(uploaded_file_params[:source_csv_file].read, headers: true) 

    table.each_with_index do |row, index|
      puts row
      # next if index == 0 # skip headers
      # subscriber = Subscriber.find_or_initialize_by(email: row[1])
      # subscriber.name = row[0]
      # next unless subscriber.valid? # skip if subscriber data is invalid
      # imported_subscriber << {name: subscriber.name, email: subscriber.email}
    end

    # puts "foo: ", table
    # do |row, ndx|
    #   puts ndx, " - ", row.inspect
    # end

    @uploaded_file = UploadedFile.new(uploaded_file_params)

    respond_to do |format|
      if @uploaded_file.save
        format.html { redirect_to uploaded_file_url(@uploaded_file), notice: "Uploaded file was successfully created." }
        format.json { render :show, status: :created, location: @uploaded_file }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @uploaded_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uploaded_files/1 or /uploaded_files/1.json
  def update
    respond_to do |format|
      if @uploaded_file.update(uploaded_file_params)
        format.html { redirect_to uploaded_file_url(@uploaded_file), notice: "Uploaded file was successfully updated." }
        format.json { render :show, status: :ok, location: @uploaded_file }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @uploaded_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploaded_files/1 or /uploaded_files/1.json
  def destroy
    @uploaded_file.destroy

    respond_to do |format|
      format.html { redirect_to uploaded_files_url, notice: "Uploaded file was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_uploaded_file
      @uploaded_file = UploadedFile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def uploaded_file_params
      params.require(:uploaded_file)
    end
end
