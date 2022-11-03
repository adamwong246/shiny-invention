class MassDataPointsController < ApplicationController
  before_action :set_mass_data_point, only: %i[ show edit update destroy ]

  # GET /mass_data_points or /mass_data_points.json
  def index
    @mass_data_points = MassDataPoint.all
  end

  # GET /mass_data_points/1 or /mass_data_points/1.json
  def show
  end

  # GET /mass_data_points/new
  def new
    @mass_data_point = MassDataPoint.new
  end

  # GET /mass_data_points/1/edit
  def edit
  end

  # POST /mass_data_points or /mass_data_points.json
  def create
    @mass_data_point = MassDataPoint.new(mass_data_point_params)

    respond_to do |format|
      if @mass_data_point.save
        format.html { redirect_to mass_data_point_url(@mass_data_point), notice: "Mass data point was successfully created." }
        format.json { render :show, status: :created, location: @mass_data_point }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @mass_data_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mass_data_points/1 or /mass_data_points/1.json
  def update
    respond_to do |format|
      if @mass_data_point.update(mass_data_point_params)
        format.html { redirect_to mass_data_point_url(@mass_data_point), notice: "Mass data point was successfully updated." }
        format.json { render :show, status: :ok, location: @mass_data_point }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @mass_data_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mass_data_points/1 or /mass_data_points/1.json
  def destroy
    @mass_data_point.destroy

    respond_to do |format|
      format.html { redirect_to mass_data_points_url, notice: "Mass data point was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mass_data_point
      @mass_data_point = MassDataPoint.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mass_data_point_params
      params.require(:mass_data_point).permit(:recordedAt, :mass, :unit)
    end
end
