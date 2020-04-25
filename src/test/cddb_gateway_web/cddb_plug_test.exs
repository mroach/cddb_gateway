defmodule CddbGatewayWeb.CddbPlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias CddbGatewayWeb.CddbPlug

  # TODO: Mock-out the calls to MusicBrainz
  @tag capture_log: true
  test "query and read cycle" do
    proto = 5

    cmd =
      "cddb+query+940aac0d+13+150+15239+29625+45763+61420+75862+91642+108918+123698+139895+153589+169239+188495+2734"

    query_req = conn(:get, "?cmd=#{cmd}&proto=#{proto}")
    query_resp = CddbPlug.call(query_req, %{})

    expected = ~S"""
    210 Found exact matches, list follows (until terminating `.')
    misc 940aac0d Marina & the Diamonds / The Family Jewels
    misc 940aac0d Marina & the Diamonds / The Family Jewels
    misc 940aac0d Marina & the Diamonds / The Family Jewels
    .
    """

    assert query_resp.resp_body == expected

    read_req = conn(:get, "?cmd=cddb+read+data+940aac0d&proto=#{proto}")
    read_resp = CddbPlug.call(read_req, %{})

    expected_read = ~S"""
    210 misc 940aac0d CD database entry follows (until terminating `.')
    DISCID=940aac0d
    DTITLE=Marina & the Diamonds / The Family Jewels
    DYEAR=2010
    DGENRE=misc
    TTITLE0=Are You Satisfied?
    TTITLE1=Shampain
    TTITLE2=I Am Not a Robot
    TTITLE3=Girls
    TTITLE4=Mowgli’s Road
    TTITLE5=Obsessions
    TTITLE6=Hollywood
    TTITLE7=The Outsider
    TTITLE8=Hermit the Frog
    TTITLE9=Oh No!
    TTITLE10=Rootless
    TTITLE11=Numb
    TTITLE12=Guilty
    EXTD=
    EXTT0=
    EXTT1=
    EXTT2=
    EXTT3=
    EXTT4=
    EXTT5=
    EXTT6=
    EXTT7=
    EXTT8=
    EXTT9=
    EXTT10=
    EXTT11=
    EXTT12=
    PLAYORDER=
    .
    """

    assert read_resp.resp_body == expected_read
  end
end