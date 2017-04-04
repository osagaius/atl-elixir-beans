defmodule Beans.Router do
  use Beans.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Beans do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api/v1/", Beans do
    pipe_through :api

    get "/classification", ClassificationController, :get_classification
    post "/classification", ClassificationController, :add_bean_classification
  end

  # Other scopes may use custom stacks.
  # scope "/api", Beans do
  #   pipe_through :api
  # end
end
