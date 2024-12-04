class StaticPagesController < ApplicationController
  def contact
    @page = Page.find_by(title: "Contact")
  end

  def about
    @page = Page.find_by(title: "About")
  end
end
