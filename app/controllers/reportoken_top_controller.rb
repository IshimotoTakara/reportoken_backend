class ReportokenTopController < ApplicationController
  def home
  end

  def help
    render :plain => 'Reportokenの使い方'
  end
end
