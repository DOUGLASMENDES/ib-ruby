require 'ib-ruby/models/model'

# TODO: Implement equals() according to the criteria in IB's Java client.

module IB
  module Models
    class Order < Model

      # General Notes:
      # 1. Placing Orders by con_id - When you place an order by con_id, you must
      # provide the con_id AND the exchange. If you provide extra fields when placing
      # an order by conid, the order may not work.

      # 2. Order IDs - Each order you place must have a unique Order ID. We recommend
      # that you increment your own Order IDs to avoid conflicts between orders placed
      # from your API application.

      # Constants used in Order objects. Drawn from Order.java
      Origin_Customer = 0
      Origin_Firm = 1

      Opt_Unknown = '?'
      Opt_Broker_Dealer = 'b'
      Opt_Customer = 'c'
      Opt_Firm = 'f'
      Opt_Isemm = 'm'
      Opt_Farmm = 'n'
      Opt_Specialist = 'y'

      OCA_Cancel_with_block = 1
      OCA_Reduce_with_block = 2
      OCA_Reduce_non_block = 3

      # Box orders consts:
      Box_Auction_Match = 1
      Box_Auction_Improvement = 2
      Box_Auction_Transparent = 3

      # Volatility orders consts:
      Volatility_Type_Daily = 1
      Volatility_Type_Annual = 2
      Volatility_Ref_Price_Average = 1
      Volatility_Ref_Price_BidOrAsk = 2

      # No idea why IB uses a large number as the default for some fields
      Max_Value = 99999999

      # Main order fields
      attr_accessor :id, #        int: m_orderId? Order id associated with client (volatile).
                    :client_id, # int: The id of the client that placed this order.
                    :perm_id, #   int: TWS id used to identify orders, remains
                    #                  the same over TWS sessions.
                    :action, #    String: Identifies the side: BUY/SELL/SSHORT
                    :total_quantity, #  int: The order quantity.

                    :order_type, #   String: Identifies the order type. Valid values are:
                    #     Limit Risk:
                    #          MTL          Market-to-Limit
                    #          MKT PRT      Market with Protection
                    #          QUOTE        Request for Quote
                    #          STP          Stop
                    #          STP LMT      Stop Limit
                    #          TRAIL        Trailing Stop
                    #          TRAIL LIMIT  Trailing Stop Limit
                    #          TRAIL LIT    Trailing Limit if Touched
                    #          TRAIL MIT    Trailing Market If Touched
                    #     Speed of Execution:
                    #          MKT          Market
                    #          MIT          Market-if-Touched
                    #          MOC          Market-on-Close    MKTCLSL ?
                    #          MOO          Market-on-Open
                    #          PEG MKT      Pegged-to-Market
                    #          REL          Relative
                    #     Price Improvement:
                    #          BOX TOP      Box Top
                    #          LOC          Limit-on-Close       LMTCLS ?
                    #          LOO          Limit-on-Open
                    #          LIT          Limit if Touched
                    #          PEG MID      Pegged-to-Midpoint
                    #          VWAP         VWAP-Guaranteed
                    #     Advanced Trading:
                    #          OCA          One-Cancels-All
                    #          VOL          Volatility
                    #          SCALE        Scale
                    #     Other (no abbreviation):
                    #          Bracket
                    #          At Auction
                    #          Discretionary
                    #          Sweep-to-Fill
                    #          Price Improvement Auction
                    #          Block
                    #          Hidden
                    #          Iceberg/Reserve
                    #          All-or-None
                    #          Fill-or-Kill

                    :limit_price, # double: This is the LIMIT price, used for limit,
                    #               stop-limit and relative orders. In all other cases
                    #               specify zero. For relative orders with no limit price,
                    #               also specify zero.

                    :aux_price, #   double: This is the STOP price for stop-limit orders,
                    #               and the offset amount for relative orders. In all other
                    #               cases, specify zero.
                    #:shares_allocation, # deprecated sharesAllocation field

                    # Extended order fields
                    :tif, #         String: Time to Market:
                    #          DAY
                    #          GAT          Good-after-Time/Date
                    #          GTD          Good-till-Date/Time
                    #          GTC          Good-till-Canceled
                    #          IOC          Immediate-or-Cancel
                    :oca_group, #   String: one cancels all group name
                    :oca_type, # int: Tells how to handle remaining orders in an OCA group
                    #            when one order or part of an order executes. Valid values:
                    #            - 1 = Cancel all remaining orders with block
                    #            - 2 = Remaining orders are reduced in size with block
                    #            - 3 = Remaining orders are reduced in size with no block
                    #             If you use a value "with block" your order has
                    #             overfill protection. This means that only one order in
                    #             the group will be routed at a time to remove the
                    #             possibility of an overfill.
                    :transmit, #  bool:if false, order will be created but not transmitted.
                    :parent_id, # int: The order ID of the parent (original) order, used
                    #             for bracket (STP) and auto trailing stop (TRAIL) orders.
                    :block_order, #    bool: the order is an ISE Block order.
                    :sweep_to_fill, #  bool: the order is a Sweep-to-Fill order.
                    :display_size, #   int: publicly disclosed order size for Iceberg orders.

                    :trigger_method, # Specifies how Simulated Stop, Stop-Limit and Trailing
                    #                  Stop orders are triggered. Valid values are:
                    #      0 - Default, "double bid/ask" method will be used for OTC stocks
                    #          and US options orders, "last" method will be used all others.
                    #      1 - "double bid/ask" method, stop orders are triggered based on
                    #          two consecutive bid or ask prices.
                    #      2 - "last" method, stops are triggered based on the last price.
                    #      3 - double last method.
                    #      4 - bid/ask method. For a buy order, a single occurrence of the
                    #          bid price must be at or above the trigger price. For a sell
                    #          order, a single occurrence of the ask price must be at or
                    #          below the trigger price.
                    #      7 - last or bid/ask method. For a buy order, a single bid price
                    #          or the last price must be at or above the trigger price.
                    #          For a sell order, a single ask price or the last price
                    #          must be at or below the trigger price.
                    #      8 - mid-point method, where the midpoint must be at or above
                    #          (for a buy) or at or below (for a sell) the trigger price,
                    #          and the spread between the bid and ask must be less than
                    #          0.1% of the midpoint

                    :outside_rth, # bool: allows orders to also trigger or fill outside
                    #               of regular trading hours. (WAS: ignore_rth)
                    :hidden, #      bool: the order will not be visible when viewing
                    #               the market depth. Only for ISLAND exchange.
                    :good_after_time, # FORMAT: 20060505 08:00:00 {time zone}
                    #                  Use an empty String if not applicable.
                    :good_till_date, #  FORMAT: 20060505 08:00:00 {time zone}
                    #                  Use an empty String if not applicable.
                    :override_percentage_constraints, # bool: Precautionary constraints
                    # are defined on the TWS Presets page, and help ensure that your
                    # price and size order values are reasonable. Orders sent from the API
                    # are also validated against these safety constraints, and may be
                    # rejected if any constraint is violated. To override validation,
                    # set this parameter�s value to True.

                    :rule_80a, # Individual = 'I', Agency = 'A', AgentOtherMember = 'W',
                    #            IndividualPTIA = 'J', AgencyPTIA = 'U', AgentOtherMemberPTIA = 'M',
                    #            IndividualPT = 'K', AgencyPT = 'Y', AgentOtherMemberPT = 'N'
                    :all_or_none, #      bool: yes=1, no=0
                    :min_quantity, #     int: Identifies a minimum quantity order type.
                    :percent_offset, #   double: percent offset amount for relative (REL)orders only
                    :trail_stop_price, # double: for TRAILLIMIT orders only

                    # Financial advisors only - use an empty String if not applicable.
                    :fa_group, :fa_profile, :fa_method, :fa_percentage,

                    # Institutional orders only!
                    :open_close, #      String: O=Open, C=Close
                    :origin, #          0=Customer, 1=Firm
                    :order_ref, #   String: The order reference. For institutional customers only.
                    :short_sale_slot, # 1 - you hold the shares,
                    #                   2 - they will be delivered from elsewhere.
                    #                   Only for Action="SSHORT
                    :designated_location, # String: set when slot==2 only
                    :exempt_code, #         int

                    #  Clearing info
                    :account, #  String: The account. For institutional customers only.
                    :settling_firm, #    String: Institutional only
                    :clearing_account, # String: For IBExecution customers: Specifies the
                    #                  true beneficiary of the order. This value is required
                    #                  for FUT/FOP orders for reporting to the exchange.
                    :clearing_intent, # For IBExecution customers: "", IB, Away,
                    #                    and PTA (post trade allocation).

                    # SMART routing only
                    :discretionary_amount, # double: The amount off the limit price
                    #                        allowed for discretionary orders.
                    :etrade_only, #     bool: Trade with electronic quotes.
                    :firm_quote_only, # bool: Trade with firm quotes.
                    :nbbo_price_cap, #  double: Maximum Smart order distance from the NBBO.

                    # BOX or VOL ORDERS ONLY
                    :auction_strategy, # For BOX exchange only. Valid values:
                    #      1=AUCTION_MATCH, 2=AUCTION_IMPROVEMENT, 3=AUCTION_TRANSPARENT
                    :starting_price, #   double: Starting price. Valid on BOX orders only.
                    :stock_ref_price, #  double: The stock reference price, used for VOL
                    # orders to compute the limit price sent to an exchange (whether or not
                    # Continuous Update is selected), and for price range monitoring.
                    :delta, #            double: Stock delta. Valid on BOX orders only.

                    # Pegged to stock or VOL orders. For price improvement option orders
                    # on BOX and VOL orders with dynamic management:
                    :stock_range_lower, #   double: The lower value for the acceptable
                    #                               underlying stock price range.
                    :stock_range_upper, #   double  The upper value for the acceptable
                    #                               underlying stock price range.

                    # VOLATILITY ORDERS ONLY:
                    :volatility, #  double: What the price is, computed via TWSs Options
                    #               Analytics. For VOL orders, the limit price sent to an
                    #               exchange is not editable, as it is the output of a
                    #               function. Volatility is expressed as a percentage.
                    :volatility_type, # int: How the volatility is calculated: 1=daily, 2=annual
                    :reference_price_type, # int: For dynamic management of volatility orders:
                    #     - 1 = Average of National Best Bid or Ask,
                    #     - 2 = National Best Bid when buying a call or selling a put;
                    #           and National Best Ask when selling a call or buying a put.
                    :delta_neutral_order_type, # String: Enter an order type to instruct TWS
                    #    to submit a delta neutral trade on full or partial execution of the
                    #    VOL order. For no hedge delta order to be sent, specify NONE.
                    :delta_neutral_aux_price, #  double: Use this field to enter a value if
                    #           the value in the deltaNeutralOrderType field is an order
                    #           type that requires an Aux price, such as a REL order.
                    :continuous_update, # int: Used for dynamic management of volatility
                    # orders. Determines whether TWS is supposed to update the order price
                    # as the underlying moves. If selected, the limit price sent to an
                    # exchange is modified by TWS if the computed price of the option
                    # changes enough to warrant doing so. This is very helpful in keeping
                    # the limit price sent to the exchange up to date as the underlying price changes.

                    # COMBO ORDERS ONLY:
                    :basis_points, #      double: EFP orders only
                    :basis_points_type, # double: EFP orders only

                    # SCALE ORDERS ONLY
                    :scale_init_level_size, # int: Size of the first (initial) order component.
                    :scale_subs_level_size, # int: Order size of the subsequent scale order
                    #             components. Used in conjunction with scaleInitLevelSize().
                    :scale_price_increment, # double: Defines the price increment between
                    # scale components. This field is required for Scale orders.

                    # ALGO ORDERS ONLY
                    :algo_strategy, # String
                    :algo_params, # public Vector<TagValue> m_algoParams; ?!

                    # WTF?!
                    :what_if, # bool: Use to request pre-trade commissions and margin
                    # information. If set to true, margin and commissions data is received
                    # back via the OrderState() object for the openOrder() callback.
                    :not_held # public boolean  m_notHeld; // Not Held

      # Some Order properties (received back from IB) are separated into
      # OrderState object. Here, they are lumped into Order proper: see OrderState.java
      attr_accessor :status, # String: Displays the order status.Possible values include:
                    # � PendingSubmit - indicates that you have transmitted the order, but
                    #   have not yet received confirmation that it has been accepted by the
                    #   order destination. NOTE: This order status is NOT sent back by TWS
                    #   and should be explicitly set by YOU when an order is submitted.
                    # � PendingCancel - indicates that you have sent a request to cancel
                    #   the order but have not yet received cancel confirmation from the
                    #   order destination. At this point, your order cancel is not confirmed.
                    #   You may still receive an execution while your cancellation request
                    #   is pending. NOTE: This order status is not sent back by TWS and
                    #   should be explicitly set by YOU when an order is canceled.
                    # � PreSubmitted - indicates that a simulated order type has been
                    #   accepted by the IB system and that this order has yet to be elected.
                    #   The order is held in the IB system until the election criteria are
                    #   met. At that time the order is transmitted to the order destination
                    #   as specified.
                    # � Submitted - indicates that your order has been accepted at the order
                    #   destination and is working.
                    # � Cancelled - indicates that the balance of your order has been
                    #   confirmed canceled by the IB system. This could occur unexpectedly
                    #   when IB or the destination has rejected your order.
                    # � ApiCancelled - canceled via API
                    # � Filled - indicates that the order has been completely filled.
                    # � Inactive - indicates that the order has been accepted by the system
                    #   (simulated orders) or an exchange (native orders) but that currently
                    #   the order is inactive due to system, exchange or other issues.
                    :init_margin, # String: Shows the impact the order would have on your
                    #                       initial margin.
                    :maint_margin, # String: Shows the impact the order would have on your
                    #                        maintenance margin.
                    :equity_with_loan, # String: Shows the impact the order would have on
                    #                            your equity with loan value.
                    :commission, # double: Shows the commission amount on the order.
                    :commission_currency, # String: Shows the currency of the commission.

                    #The possible range of the actual order commission:
                    :min_commission,
                    :max_commission,

                    :warning_text # String: Displays a warning message if warranted.

      alias order_id id # TODO: Change due to ActiveRecord specifics
      alias order_id= id= # TODO: Change due to ActiveRecord specifics

      # IB uses weird String with Java Double.MAX_VALUE to indicate no value here
      def init_margin= val
        @init_margin = val == "1.7976931348623157E308" ? nil : val
      end

      # IB uses weird String with Java Double.MAX_VALUE to indicate no value here
      def maint_margin= val
        @maint_margin = val == "1.7976931348623157E308" ? nil : val
      end

      # IB uses weird String with Java Double.MAX_VALUE to indicate no value here
      def equity_with_loan= val
        @equity_with_loan = val == "1.7976931348623157E308" ? nil : val
      end

      def initialize opts = {}
        # Assign defaults first!
        @aux_price = 0.0
        @parent_id=0
        @tif='DAY'

        @outside_rth = false
        @open_close = "O"
        @origin = Origin_Customer
        @transmit = true
        @designated_location = ''
        @exempt_code = -1
        @delta_neutral_order_type = ''
        @what_if = false
        @not_held = false
        @algo_strategy = ''
        @algo_params = []

        # TODO: Initialize with nil instead of Max_Value, or change
        #       Order sending code in IB::Messages::Outgoing::PlaceOrder
        #@min_quantity = Max_Value
        #@percent_offset = Max_Value # -"-
        #@nbbo_price_cap = Max_Value # -"-
        #@starting_price = Max_Value # -"-
        #@stock_ref_price = Max_Value # -"-
        #@delta = Max_Value
        #@stock_range_lower = Max_Value # -"-
        #@stock_range_upper = Max_Value # -"-
        #@volatility = Max_Value # -"-
        #@volatility_type = Max_Value # -"-
        #@delta_neutral_aux_price = Max_Value # -"-
        #@reference_price_type = Max_Value # -"-
        #@trail_stop_price = Max_Value # -"-
        #@basis_points = Max_Value # -"-
        #@basis_points_type = Max_Value # -"-
        #@scale_init_level_size = Max_Value # -"-
        #@scale_subs_level_size = Max_Value # -"-
        #@scale_price_increment = Max_Value # -"-
        #@reference_price_type = Max_Value # -"-
        #@reference_price_type = Max_Value # -"-
        #@reference_price_type = Max_Value # -"-
        #@reference_price_type = Max_Value # -"-

        super opts
      end

      # This returns an Array of data from the given order,
      # mixed with data from associated contract. Ugly mix, indeed.
      def serialize_with contract
        [contract.serialize_long(:con_id, :sec_id),
         action, # main order fields
         total_quantity,
         order_type,
         limit_price,
         aux_price,
         tif, # xtended order fields
         oca_group,
         account,
         open_close,
         origin,
         order_ref,
         transmit,
         parent_id,
         block_order,
         sweep_to_fill,
         display_size,
         trigger_method,
         outside_rth, # was: ignore_rth
         hidden,
         contract.serialize_legs(:extended),
         '', # deprecated shares_allocation field
         discretionary_amount,
         good_after_time,
         good_till_date,
         fa_group,
         fa_method,
         fa_percentage,
         fa_profile,
         short_sale_slot, #     0 only for retail, 1 or 2 for institution  (Institutional)
         designated_location, # only populate when short_sale_slot == 2    (Institutional)
         oca_type,
         rule_80a,
         settling_firm,
         all_or_none,
         min_quantity || EOL,
         percent_offset || EOL,
         etrade_only,
         firm_quote_only,
         nbbo_price_cap || EOL,
         auction_strategy || EOL,
         starting_price || EOL,
         stock_ref_price || EOL,
         delta || EOL,
         stock_range_lower || EOL,
         stock_range_upper || EOL,
         override_percentage_constraints,
         volatility || EOL, #              Volatility orders
         volatility_type || EOL, #         Volatility orders
         delta_neutral_order_type, #       Volatility orders
         delta_neutral_aux_price || EOL, # Volatility orders
         continuous_update, #              Volatility orders
         reference_price_type || EOL, #    Volatility orders
         trail_stop_price || EOL, #        TRAIL_STOP_LIMIT stop price
         scale_init_level_size || EOL, #   Scale Orders
         scale_subs_level_size || EOL, #   Scale Orders
         scale_price_increment || EOL, #   Scale Orders
         clearing_account,
         clearing_intent,
         not_held,
         contract.serialize_under_comp,
         serialize_algo,
         what_if]
      end

      # Order comparison
      def == other
        perm_id == other.perm_id ||
            order_id == other.order_id && #   ((p __LINE__)||true) &&
                client_id == other.client_id &&
                parent_id == other.parent_id &&
                tif == other.tif &&
                action == other.action &&
                order_type == other.order_type &&
                total_quantity == other.total_quantity &&
                limit_price == other.limit_price &&
                aux_price == other.aux_price &&
                outside_rth == other.outside_rth &&
                origin == other.origin &&
                transmit == other.transmit &&
                designated_location == other.designated_location &&
                exempt_code == other.exempt_code &&
                what_if == other.what_if &&
                not_held == other.not_held &&
                algo_strategy == other.algo_strategy &&
                algo_params == other.algo_params

        # TODO: || compare all attributes!
      end

      def serialize_algo
        if algo_strategy.nil? || algo_strategy.empty?
          ['']
        else
          [algo_strategy,
           algo_params.size,
           algo_params.to_a]
        end
      end

      def to_s #human
        "<Order:" + instance_variables.map do |key|
          value = instance_variable_get(key)
          " #{key}=#{value}" unless value.nil? || value == '' || value == 0
        end.compact.join(',') + " >"
      end

      def to_human
        "<Order: #{order_type} #{tif} #{action} #{total_quantity} #{status} #{limit_price}" +
            " id: #{order_id}/#{perm_id} from: #{client_id}/#{account}>"
      end
    end # class Order
  end # module Models
end # module IB
