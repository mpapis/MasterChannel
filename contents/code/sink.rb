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

module MasterChannel
  class Sink
    attr_reader :index, :name, :default

    def initialize(index, name, default)
      @index   = index
      @name    = name
      @default = default
    end

    def short_name
      name.gsub(/alsa_output./,'')[0..40]
    end

    def to_s
      "#{index}: #{short_name} (default:#{default})"
    end
  end
end
