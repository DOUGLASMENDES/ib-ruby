# Stock contracts definitions
#
# Note that the :description field is particular to ib-ruby, and is NOT part of the
# standard TWS API. It is never transmitted to IB. It's purely used clientside, and
# you can store any arbitrary string that you may find useful there.

module IB
  module Symbols

    Options =
        {:wfc20 => Models::Contract::Option.new(:symbol => "WFC",
                                                :exchange => "SMART",
                                                :expiry => "201207",
                                                :right => "CALL",
                                                :strike => 20.0,
                                                :description => "Wells Fargo 20 Call 2012-07"),
         :z50 => Models::Contract::Option.new(:symbol => "Z",
                                              :exchange => "LIFFE",
                                              :expiry => "201206",
                                              :right => "CALL",
                                              :strike => 50.0,
                                              :description => " FTSE-100 index 50 Call 2012-06"),
         :spy75 => Models::Contract::Option.new(:symbol => 'SPY',
                                                :exchange => "SMART",
                                                :expiry => "20120615",
                                                :right => "P",
                                                :currency => "USD",
                                                :strike => 75.0,
                                                :description => "SPY 75.0 Put 2012-06-16"),
         :spy100 => Models::Contract::Option.new(:osi => 'SPY 121222P00100000',
                                                 :exchange => "SMART"),
        }
  end
end
