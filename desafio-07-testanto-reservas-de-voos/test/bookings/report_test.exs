# Este teste é opcional, mas vale a pena tentar e se desafiar 😉

defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  alias Flightex.Bookings.Report

  describe "generate/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)
      Report.generate("report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end
  end

  describe "generate_report/2" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, returns the booking betweem dates specified" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      Flightex.create_or_update_booking(params)

      params = %{
        complete_date: ~N[2001-05-08 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      Flightex.create_or_update_booking(params)

      params = %{
        complete_date: ~N[2001-05-09 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      Flightex.create_or_update_booking(params)

      Report.generate("report-test-2.csv")

      response = Report.generate_report("2001-05-08 12:00:00", "2001-05-09 13:00:00")

      expected_response = [
        "12345678900,Brasilia,Bananeiras,2001-05-08 12:00:00\n",
        "12345678900,Brasilia,Bananeiras,2001-05-09 12:00:00\n"
      ]

      assert response == expected_response
    end
  end
end
