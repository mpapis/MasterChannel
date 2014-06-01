# <Copyright and license information goes here.>

require 'plasma_applet'
require_relative 'pulseaudio'
require_relative 'kmix'

module MasterChannel
  class Main < PlasmaScripting::Applet
    def initialize parent
      super parent
    end

    def init
      self.has_configuration_interface = false

      layout = Qt::GraphicsLinearLayout.new Qt::Vertical, self
      self.layout = layout
      @label = Plasma::Label.new self
      layout.add_item @label

      @pulseaudio = Pulseaudio.new
      @kmix = KMix.new
      set_label(best_sink_name(@pulseaudio.default_sink))
    end

    def contextualActions()
      @pulseaudio.list_sinks.map{|sink| new_action(sink) }
    end

    def new_action(sink)
      action = Qt::Action.new self
      action.text = best_sink_name(sink)
      action.connect(SIGNAL(:triggered)) do
        set_label action.text
        @pulseaudio.default_sink = sink
        @kmix.set_default_channel(sink.name) if @kmix.available?
      end
      action
    end

    def set_label(name)
      @label.text = "Master Channel:\n#{name}"
    end

    def best_sink_name(sink)
      if @kmix.available?
      then @kmix.readable_name(sink.name) || sink.short_name
      else sink.short_name
      end
    end

  end
end
