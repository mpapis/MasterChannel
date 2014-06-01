require 'Qt'
require_relative 'sink'

module MasterChannel
  class KMix
    def initialize
      @mixers   = {}
      @controls = {}
    end

    def dbus
      @dbus ||= Qt::DBusConnection.sessionBus
    end

    def mixset
      @mixset ||= Qt::DBusInterface.new("org.kde.kmix", "/Mixers", "org.kde.KMix.MixSet", @dbus)
    end

    def available?
      dbus.connected? && mixset.valid?
    end

    def playback_mixers
      mixset.property("mixers").value.grep(/Playback_Devices/)
    end

    def find_mixer_for(name)
      if playback_mixers.size == 1
      then mixer = playback_mixers.first
      else mixer = playback_mixers.first #TODO actually find it using name
      end
      get_dbus_device(mixer).property("id").value
    end

    def set_default_channel(name)
      mixer = find_mixer_for(name)
      @mixset.call("setCurrentMaster", mixer, name)
    end

    def readable_name(name)
      mixer, device = mixer_and_device_for_name(name)
      device.property('readableName').value if device
    end

    def mixer_and_device_for_name(name)
      playback_mixers.map{|mixer|
        device =
        get_dbus_device(mixer).property("controls").value.map{|control|
          interface = get_dbus_control(control)
          interface if interface.property('id').value == name
        }.compact.first
        [mixer, device] if device
      }.compact.first
    end



    def get_dbus_device(mixer)
      @mixers[mixer] ||=
        Qt::DBusInterface.new(
          "org.kde.kmix", mixer, "org.kde.KMix.Mixer", @dbus
        )
    end

    def get_dbus_control(control)
      @controls[control] ||=
        Qt::DBusInterface.new(
          "org.kde.kmix", control, "org.kde.KMix.Control", @dbus
        )
    end

  end
end
