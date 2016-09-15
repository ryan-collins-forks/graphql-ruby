module GraphQL
  # # Instrumentation
  #
  # `graphql-ruby` includes a framework for
  # tracing events in schemas and queries, `GraphQL::Instrumentation`.
  # You can use this framework to measure and customize your GraphQL implementation.
  #
  # You can register handlers to events by name:
  #
  # ```ruby
  # Schema.define do
  #   instrument(:query_start) { |trace, event| trace[:query_started_at] = Time.now }
  #   instrument(:query_end)   { |trace, event| trace[:query_ended_at] = Time.now }
  # end
  # ```
  #
  # Events are triggered with two values:
  #
  # - `trace` is the instrumentation state for this query. It is passed to _all_
  #   instrumentation handlers, and they may _all_ read and write on it, so take care!
  #   (TODO: is there a better name for this concept?)
  # - `event` is a hash of values for this specific event. Each event has its own
  #   values, so check the documentation for the specific event to know what is present here.
  #
  # Then, events are triggered from {GraphQL::Query} objects.
  # (Most events are triggered by `graphql-ruby` internals, but you may trigger your own events, too).
  # For example:
  #
  # ```ruby
  # query.instrument(:query_start)
  # # evaluate the query ...
  # query.instrument(:query_end)
  # ```
  #
  # `:field_resolve` is a bit special. It yields control of field resolution to the event handler.
  # To resolve the field, you must call `event[:resolve]`. For example, to time field resolution:
  #
  # ```ruby
  # Schema.define do
  #   instrument(:query_start) { |trace, event| trace[:field_resolves] = [] }
  #
  #   instrument(:field_resolve) do |trace, event|
  #
  #     field_resolve_data = {
  #       started_at: Time.now,
  #       field: event[:field],
  #       type: event[:type],
  #       arguments: event[:arguments],
  #     }
  #
  #     event[:resolve].call
  #
  #     field_resolve_data[:ended_at] = Time.now
  #
  #     trace[:field_resolves] << field_resolve_data
  #   end
  # end
  # ```
  #
  # `graphql-ruby` emits some events by default:
  # - `:query_start`: A query has been parsed and analyzed, and will now be executed
  # - `:field_resolve`: A specific selection is about to be resolved by the user-provided `resolve` function
  # - `:query_end`: Query execution is finished; all fields were resolved and the result will be returned to the caller
  # - TODO: consider other relevant lifecycle events
  #
  module Instrumentation
  end
end
