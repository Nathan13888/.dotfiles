/**
 * @name OnlineFriendCount
 * @author Zerthox
 * @version 1.3.0
 * @description Add the old online friend count back to guild list. Because nostalgia.
 * @source https://github.com/Zerthox/BetterDiscord-Plugins
 */

/*@cc_on
	@if (@_jscript)
		var name = WScript.ScriptName.split(".")[0];
		var shell = WScript.CreateObject("WScript.Shell");
		var fso = new ActiveXObject("Scripting.FileSystemObject");
		shell.Popup("Do NOT run random scripts from the internet with the Windows Script Host!\n\nYou are supposed to move this file to your BandagedBD/BetterDiscord plugins folder.", 0, name + ": Warning!", 0x1030);
		var pluginsPath = shell.expandEnvironmentStrings("%appdata%\\BetterDiscord\\plugins");
		if (!fso.FolderExists(pluginsPath)) {
			if (shell.Popup("Unable to find the BetterDiscord plugins folder on your computer.\nOpen the download page of BandagedBD/BetterDiscord?", 0, name + ": BetterDiscord installation not found", 0x14) === 6) {
				shell.Exec("explorer \"https://github.com/rauenzi/betterdiscordapp/releases\"");
			}
		}
		else if (WScript.ScriptFullName === pluginsPath + "\\" + WScript.ScriptName) {
			shell.Popup("This plugin is already in the correct folder.\nNavigate to the \"Plugins\" settings tab in Discord and enable it there.", 0, name, 0x40);
		}
		else {
			shell.Exec("explorer " + pluginsPath);
		}
		WScript.Quit();
	@else
@*/

const {React, ReactDOM} = BdApi,
	Flux = BdApi.findModuleByProps("connectStores");

function qReact(node, query) {
	let match = false;

	try {
		match = query(node);
	} catch (err) {
		console.debug("Suppressed error in qReact query:\n", err);
	}

	if (match) {
		return node;
	} else if (node && node.props && node.props.children) {
		for (const child of [node.props.children].flat()) {
			const result = arguments.callee(child, query);

			if (result) {
				return result;
			}
		}
	}

	return null;
}

const Module = {
	Status: BdApi.findModuleByProps("getStatus", "getOnlineFriendCount")
};
const Component = {
	Link: BdApi.findModuleByProps("NavLink").Link
};
const Selector = {
	guilds: BdApi.findModuleByProps("guilds", "base"),
	list: BdApi.findModuleByProps("listItem"),
	friendsOnline: "friendsOnline-2JkivW"
};
const Styles = `/*! OnlineFriendCount v1.3.0 styles */
.friendsOnline-2JkivW {
  color: rgba(255, 255, 255, 0.3);
  text-align: center;
  text-transform: uppercase;
  font-size: 10px;
  font-weight: 500;
  line-height: 1.3;
  width: 70px;
  word-wrap: normal;
  white-space: nowrap;
  cursor: pointer;
}

.friendsOnline-2JkivW:hover {
  color: rgba(255, 255, 255, 0.5);
}`;

function OnlineCount({online}) {
	return React.createElement(
		"div",
		{
			className: Selector.list.listItem
		},
		React.createElement(
			Component.Link,
			{
				to: {
					pathname: "/channels/@me"
				}
			},
			React.createElement(
				"div",
				{
					className: Selector.friendsOnline
				},
				online,
				" Online"
			)
		)
	);
}

const OnlineCountContainer = Flux.connectStores([Module.Status], () => ({
	online: Module.Status.getOnlineFriendCount()
}))(OnlineCount);

class Plugin {
	start() {
		this.injectCSS(Styles);
		let fiber = BdApi.getInternalInstance(document.getElementsByClassName(Selector.guilds.guilds)[0]);

		if (!fiber) {
			this.error("Error patching Guilds: Cannot find Guilds element fiber");
			return;
		}

		while (!fiber.type || fiber.type.displayName !== "Guilds") {
			if (!fiber.return) {
				this.error("Error patching Guilds: Cannot find Guilds Component");
				return;
			}

			fiber = fiber.return;
		}

		this.createPatch(fiber.type.prototype, "render", {
			after: ({returnValue}) => {
				const scroller = qReact(returnValue, (e) => e.type.displayName === "VerticalScroller");

				if (!scroller) {
					this.error("Error during render: Cannot find VerticalScroller Component");
					return;
				}

				if (!qReact(scroller, (e) => e.props.className === Selector.friendsOnline)) {
					const {children} = scroller.props;
					const index = children.indexOf(
						qReact(scroller, (e) => e.type.displayName === "ConnectedUnreadDMs")
					);
					children.splice(index > -1 ? index : 1, 0, React.createElement(OnlineCountContainer, null));
				}
			}
		});
		fiber.stateNode.forceUpdate();
	}

	stop() {
		this.forceUpdate(Selector.guilds.guilds);
	}
}

module.exports = class Wrapper extends Plugin {
	getName() {
		return "OnlineFriendCount";
	}

	getVersion() {
		return "1.3.0";
	}

	getAuthor() {
		return "Zerthox";
	}

	getDescription() {
		return "Add the old online friend count back to guild list. Because nostalgia.";
	}

	log(...msgs) {
		console.log(
			`%c[${this.getName()}] %c(v${this.getVersion()})`,
			"color: #3a71c1; font-weight: 700;",
			"color: #666; font-size: .8em;",
			...msgs
		);
	}

	warn(...msgs) {
		console.warn(
			`%c[${this.getName()}] %c(v${this.getVersion()})`,
			"color: #3a71c1; font-weight: 700;",
			"color: #666; font-size: .8em;",
			...msgs
		);
	}

	error(...msgs) {
		console.error(
			`%c[${this.getName()}] %c(v${this.getVersion()})`,
			"color: #3a71c1; font-weight: 700;",
			"color: #666; font-size: .8em;",
			...msgs
		);
	}

	constructor() {
		super(...arguments);
		this._Patches = [];

		if (this.defaults) {
			this.settings = Object.assign({}, this.defaults, this.loadData("settings"));
		}
	}

	start() {
		this.log("Enabled");
		super.start();
	}

	stop() {
		while (this._Patches.length > 0) {
			this._Patches.pop()();
		}

		this.log("Unpatched all");

		if (document.getElementById(this.getName())) {
			BdApi.clearCSS(this.getName());
		}

		super.stop();

		if (this._settingsRoot) {
			ReactDOM.unmountComponentAtNode(this._settingsRoot);
			delete this._settingsRoot;
		}

		this.log("Disabled");
	}

	saveData(id, value) {
		return BdApi.saveData(this.getName(), id, value);
	}

	loadData(id, fallback = null) {
		const l = BdApi.loadData(this.getName(), id);
		return l ? l : fallback;
	}

	injectCSS(css) {
		const el = document.getElementById(this.getName());

		if (!el) {
			BdApi.injectCSS(this.getName(), css);
		} else {
			el.innerHTML += "\n\n/* --- */\n\n" + css;
		}
	}

	createPatch(target, method, options) {
		options.silent = true;

		this._Patches.push(BdApi.monkeyPatch(target, method, options));

		const name =
			options.name ||
			target.displayName ||
			target.name ||
			target.constructor.displayName ||
			target.constructor.name ||
			"Unknown";
		this.log(
			`Patched ${method} of ${name} ${
				options.type === "component" || target instanceof React.Component ? "component" : "module"
			}`
		);
	}

	async forceUpdate(...classes) {
		this.forceUpdateElements(...classes.map((e) => Array.from(document.getElementsByClassName(e))).flat());
	}

	async forceUpdateElements(...elements) {
		for (const el of elements) {
			try {
				let fiber = BdApi.getInternalInstance(el);

				if (fiber) {
					while (!fiber.stateNode || !fiber.stateNode.forceUpdate) {
						fiber = fiber.return;
					}

					fiber.stateNode.forceUpdate();
				}
			} catch (e) {
				this.warn(
					`Failed to force update "${
						el.id ? `#${el.id}` : el.className ? `.${el.className}` : el.tagName
					}" state node`
				);
				console.error(e);
			}
		}
	}
};

if (Plugin.prototype.getSettings) {
	module.exports.prototype.getSettingsPanel = function() {
		const Flex = BdApi.findModuleByDisplayName("Flex"),
			Button = BdApi.findModuleByProps("Link", "Hovers"),
			Form = BdApi.findModuleByProps("FormItem", "FormSection", "FormDivider"),
			Margins = BdApi.findModuleByProps("marginLarge");
		const SettingsPanel = Object.assign(this.getSettings(), {
			displayName: "SettingsPanel"
		});
		const self = this;

		class Settings extends React.Component {
			constructor(props) {
				super(props);
				this.state = this.props.settings;
			}

			render() {
				const props = Object.assign(
					{
						update: (e) => this.setState(e, () => this.props.update(this.state))
					},
					this.state
				);
				return React.createElement(
					Form.FormSection,
					null,
					React.createElement(
						Form.FormTitle,
						{
							tag: "h2"
						},
						this.props.name,
						" Settings"
					),
					React.createElement(SettingsPanel, props),
					React.createElement(Form.FormDivider, {
						className: [Margins.marginTop20, Margins.marginBottom20].join(" ")
					}),
					React.createElement(
						Flex,
						{
							justify: Flex.Justify.END
						},
						React.createElement(
							Button,
							{
								size: Button.Sizes.SMALL,
								onClick: () => {
									BdApi.showConfirmationModal(this.props.name, "Reset all settings?", {
										onConfirm: () => {
											this.props.reset();
											this.setState(self.settings);
										}
									});
								}
							},
							"Reset"
						)
					)
				);
			}
		}

		Settings.displayName = this.getName() + "Settings";

		if (!this._settingsRoot) {
			this._settingsRoot = document.createElement("div");
			this._settingsRoot.className = `settingsRoot-${this.getName()}`;
			ReactDOM.render(
				React.createElement(Settings, {
					name: this.getName(),
					settings: this.settings,
					update: (state) => {
						this.saveData("settings", Object.assign(this.settings, state));
						this.update && this.update();
					},
					reset: () => {
						this.saveData("settings", Object.assign(this.settings, this.defaults));
						this.update && this.update();
					}
				}),
				this._settingsRoot
			);
		}

		return this._settingsRoot;
	};
}

/*@end@*/
