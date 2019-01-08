alias Converge.{Util, RedoAfterMeet, All, SystemdUnitEnabled, SystemdUnitStarted}

defmodule RoleApcUps do
	import Util, only: [conf_file: 1, marker: 1]
	Util.declare_external_resources("files")

	def role(_tags \\ []) do
		%{
			desired_packages: ["apcupsd"],
			post_install_unit: %All{units: [
				%RedoAfterMeet{
					marker:  marker("apcupsd.service"),
					unit:    %All{units: [
						conf_file("/etc/apcupsd/apcupsd.conf"),
						conf_file("/etc/default/apcupsd"),
					]},
					trigger: fn -> {_, 0} = System.cmd("service", ["apcupsd", "restart"]) end
				},
				%SystemdUnitEnabled{name: "apcupsd.service"},
				%SystemdUnitStarted{name: "apcupsd.service"},
			]},
		}
	end
end
