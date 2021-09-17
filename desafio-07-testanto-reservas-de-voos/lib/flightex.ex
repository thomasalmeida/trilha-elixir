defmodule Flightex do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Users.Agent, as: UserAgent

  alias Flightex.Bookings.CreateOrUpdate, as: CreateOrUpdateBooking
  alias Flightex.Users.CreateOrUpdate, as: CreateOrUpdateUser

  # coveralls-ignore-start
  def start_agents do
    UserAgent.start_link(%{})
    BookingAgent.start_link(%{})
  end

  defdelegate create_or_update_booking(params), to: CreateOrUpdateBooking, as: :call
  defdelegate create_or_update_user(params), to: CreateOrUpdateUser, as: :call
  # coveralls-ignore-stop
end
