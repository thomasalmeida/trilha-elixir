defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate(filename \\ "report.csv") do
    booking_list = build_booking_list()

    File.write!(filename, booking_list)
  end

  def generate_report(from_date, to_date) do
    "report.csv"
    |> File.stream!()
    |> Enum.map(fn line -> list_booking_between_dates(line, from_date, to_date) end)
    |> Enum.reject(&is_nil/1)
  end

  defp list_booking_between_dates(line, from_date, to_date) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.last()
    |> validate_line(from_date, to_date, line)
  end

  defp validate_line(date, from_date, to_date, line) do
    case from_date <= date && date < to_date do
      true ->
        line

      false ->
        nil
    end
  end

  defp build_booking_list do
    BookingAgent.get_all()
    |> Map.values()
    |> Enum.map(fn booking -> booking_string(booking) end)
  end

  defp booking_string(%Booking{
         user_id: user_id,
         local_origin: local_origin,
         local_destination: local_destination,
         complete_date: complete_date
       }) do
    "#{user_id},#{local_origin},#{local_destination},#{complete_date}"
  end
end
