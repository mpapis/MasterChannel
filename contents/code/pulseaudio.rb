=begin
Copyright 2014 Michal Papis <mpapis@gmail.com>

This file is part of MasterChannel.

MasterChannel is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

MasterChannel is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with MasterChannel.  If not, see <http://www.gnu.org/licenses/>.
=end

require_relative 'sink'

module MasterChannel
  class Pulseaudio

    def list_sinks
      `pacmd list-sinks`.
        split("\n").
        grep(/index:|name:/).
        each_slice(2).
        map{|index, name|
          [
            index.match(/(\*)? index: (.*)$/)[1,2],
            name.match(/name: <(.*)>$/)[1]
          ].flatten
        }.
        map{|default, index, name|
          Sink.new(index, name, !!default)
        }
    end

    def default_sink
      list_sinks.detect{|sink| sink.default}
    end

    def default_sink=(sink)
      switch_sink_default(sink.index)
      switch_sink_inputs(sink.index)
    end

    def switch_sink_default(index)
      `pacmd set-default-sink #{index}`
    end

    def switch_sink_inputs(sink_id)
      list_sink_inputs_ids.map{|input_id|
        switch_sink_input(input_id, sink_id)
      }
    end

    def switch_sink_input(input_id, sink_id)
      `pacmd move-sink-input #{input_id} #{sink_id}`
    end

    def list_sink_inputs_ids
      `pacmd list-sink-inputs`.
        split("\n").
        map{|line|
          line =~ /index: (.*)$/ ; $1
        }.
        compact
    end

  end
end
