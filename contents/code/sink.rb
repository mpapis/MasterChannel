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
