class KanrisController < ApplicationController
  before_action :require_user!
  before_action :require_kanriG_user!
  def index
  end
end
