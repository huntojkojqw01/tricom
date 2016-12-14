class KeihibodiesController < ApplicationController
  before_action :require_user!
  def export_csv
    @keihibodies = Keihibody.all

    respond_to do |format|
      format.html
      format.csv { send_data @keihibodies.to_csv, filename: "経費ボディ.csv" }
    end
  end
end
