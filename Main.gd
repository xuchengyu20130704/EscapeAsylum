extends Node2D

# 模块系统
var modules = {}
var current_module = null
var dialogue_ui = null

# 游戏状态
var game_state = {
	"player_name": "玩家",
	"道德值": 50,
	"理智值": 70,
	"线索": [],
	"信任的人": [],
	"flag_见过院长": false,
	"flag_拿到文件": false,
	"flag_被发现": false,
	"flag_卧底": false,
	"当前章节": "escape",
	"当前背景": "精神病院"
}

# 背景管理
var backgrounds = {
	"精神病院": Color(0.2, 0.2, 0.3),
	"城市": Color(0.3, 0.3, 0.4),
	"警察局": Color(0.4, 0.4, 0.6),
	"黑帮据点": Color(0.5, 0.2, 0.2),
	"家里": Color(0.4, 0.3, 0.2),
	"结局": Color(0.1, 0.1, 0.1)
}

# 角色立绘颜色
var characters = {
	"系统": Color(1, 1, 1),
	"你": Color(0.6, 0.8, 1),
	"护士": Color(1, 0.8, 0.8),
	"黑狼": Color(1, 0.5, 0.5),
	"警察": Color(0.5, 0.5, 1),
	"家人": Color(0.8, 1, 0.8),
	"心理医生": Color(0.8, 0.9, 1)
}

var bg_rect = null
var character_rect = null

func _ready():
	# 创建背景
	bg_rect = ColorRect.new()
	bg_rect.size = get_viewport().get_visible_rect().size
	bg_rect.color = backgrounds["精神病院"]
	add_child(bg_rect)
	
	# 创建角色立绘区域
	character_rect = ColorRect.new()
	character_rect.size = Vector2(400, 500)
	character_rect.position = Vector2(312, 50)
	character_rect.color = Color(0, 0, 0, 0)
	add_child(character_rect)
	
	# 创建对话UI
	dialogue_ui = DialogueUI.new()
	dialogue_ui.main = self
	add_child(dialogue_ui)
	
	# 延迟加载模块和开始游戏
	call_deferred("_load_modules")
	call_deferred("_start_game")

func _load_modules():
	var module_files = [
		"res://modules/基础模块.gd",
		"res://modules/反派线.gd", 
		"res://modules/正派线.gd",
		"res://modules/回归线.gd"
	]
	
	for file_path in module_files:
		if ResourceLoader.exists(file_path):
			var module = load(file_path)
			if module:
				var module_instance = module.new()
				module_instance.game_state = game_state
				module_instance.main = self
				var module_name = file_path.get_file().replace(".gd", "")
				modules[module_name] = module_instance
				print("✅ 加载模块: ", module_name)
		else:
			print("❌ 文件不存在: ", file_path)
	
	print("✅ 已加载所有模块: ", modules.keys())

func _start_game():
	show_dialogue("系统", "【三年前】")
	await get_tree().create_timer(0.5).timeout
	show_dialogue("系统", "你被关进了北山精神病院")
	await get_tree().create_timer(0.5).timeout
	show_dialogue("系统", "你始终坚信自己没病")
	await get_tree().create_timer(0.5).timeout
	show_dialogue("系统", "【今晚】")
	await get_tree().create_timer(0.5).timeout
	show_dialogue("系统", "你终于找到了逃跑的机会...")
	
	# 等待2秒后开始游戏
	await get_tree().create_timer(2.0).timeout
	switch_module("基础模块", "escape")

func set_background(bg_name: String):
	if bg_name in backgrounds:
		bg_rect.color = backgrounds[bg_name]
		game_state.当前背景 = bg_name

func set_character(char_name: String, visible: bool = true):
	if visible and char_name in characters:
		character_rect.color = characters[char_name]
		character_rect.color.a = 0.7
	else:
		character_rect.color = Color(0, 0, 0, 0)

func switch_module(module_name: String, entry_point: String):
	var module_key = module_name + ".gd"
	if module_key in modules:
		current_module = modules[module_key]
		current_module.enter(entry_point)
	else:
		# 尝试直接查找
		for key in modules.keys():
			if key.begins_with(module_name):
				current_module = modules[key]
				current_module.enter(entry_point)
				return
		print("❌ 模块不存在: ", module_name)

func show_dialogue(speaker: String, text: String):
	dialogue_ui.show_dialogue(speaker, text)

func show_choices(choices: Array):
	dialogue_ui.show_choices(choices)

func apply_effect(effect: Dictionary):
	if not effect:
		return
	
	for key in effect:
		if key in game_state:
			var value = effect[key]
			
			if typeof(game_state[key]) == TYPE_INT and typeof(value) == TYPE_INT:
				game_state[key] += value
				if key in ["道德值", "理智值"]:
					game_state[key] = clampi(game_state[key], 0, 100)
			
			elif typeof(game_state[key]) == TYPE_ARRAY:
				if value is Array:
					game_state[key] += value
				else:
					game_state[key].append(value)
			else:
				game_state[key] = value
	
	print("📊 游戏状态更新: ", game_state)

func check_conditions(conditions: Dictionary) -> bool:
	if not conditions:
		return true
	
	for key in conditions:
		if key == "道德值":
			if game_state[key] < conditions[key]:
				return false
		elif key == "理智值":
			if game_state[key] < conditions[key]:
				return false
		elif key == "有线索":
			if conditions[key] not in game_state.线索:
				return false
		elif key == "信任":
			if conditions[key] not in game_state.信任的人:
				return false
		elif key == "flag":
			var flag_name = "flag_" + conditions[key]
			if not game_state.get(flag_name, false):
				return false
	
	return true


# ==================== DialogueUI类 ====================
class DialogueUI extends CanvasLayer:
	var main = null
	var speaker_label = null
	var text_label = null
	var choices_container = null
	var panel = null
	
	func _init():
		# 创建黑色半透明背景
		panel = ColorRect.new()
		panel.color = Color(0, 0, 0, 0.7)
		panel.custom_minimum_size = Vector2(1000, 200)
		panel.position = Vector2(12, 380)
		panel.size = Vector2(1000, 200)
		add_child(panel)
		
		# 说话人标签
		speaker_label = Label.new()
		speaker_label.name = "Speaker"
		speaker_label.position = Vector2(30, 390)
		speaker_label.add_theme_color_override("font_color", Color(1, 0.8, 0))
		speaker_label.add_theme_font_size_override("font_size", 24)
		add_child(speaker_label)
		
		# 对话文本标签
		text_label = Label.new()
		text_label.name = "DialogueText"
		text_label.position = Vector2(30, 430)
		text_label.size = Vector2(960, 140)
		text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		text_label.add_theme_color_override("font_color", Color(1, 1, 1))
		text_label.add_theme_font_size_override("font_size", 20)
		add_child(text_label)
		
		# 选项容器
		choices_container = VBoxContainer.new()
		choices_container.name = "Choices"
		choices_container.position = Vector2(30, 430)
		choices_container.size = Vector2(960, 140)
		choices_container.hide()
		add_child(choices_container)
		
		hide()
	
	func show_dialogue(speaker: String, text: String):
		show()
		speaker_label.text = speaker
		text_label.text = text
		choices_container.hide()
		text_label.show()
		
		# 根据说话人设置立绘和背景
		match speaker:
			"系统":
				if "精神病院" in text:
					main.set_background("精神病院")
				elif "城市" in text or "边缘" in text:
					main.set_background("城市")
				elif "警察" in text:
					main.set_background("警察局")
				elif "黑狼" in text or "同伙" in text:
					main.set_background("黑帮据点")
				elif "小屋" in text or "郊区" in text:
					main.set_background("家里")
				elif "结局" in text:
					main.set_background("结局")
		
		# 设置角色立绘
		if speaker in main.characters:
			main.set_character(speaker, true)
		else:
			main.set_character("", false)
		
		# 等待1.5秒自动继续
		await main.get_tree().create_timer(1.5).timeout
	
	func show_choices(choices: Array):
		text_label.hide()
		choices_container.show()
		
		# 清除旧选项
		for child in choices_container.get_children():
			child.queue_free()
		
		# 创建新选项
		for i in range(choices.size()):
			var choice = choices[i]
			var btn = Button.new()
			btn.text = str(i+1) + ". " + choice.text
			btn.custom_minimum_size = Vector2(900, 40)
			btn.pressed.connect(_on_choice_selected.bind(choice))
			choices_container.add_child(btn)
	
	func _on_choice_selected(choice):
		hide()
		main.set_character("", false)
		if main.current_module and choice.has("next"):
			main.current_module.call("on_choice_selected", choice)