class PagesController < ApplicationController
  def home
    @people = Person.all
  end
end
