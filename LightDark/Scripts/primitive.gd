@tool
extends Node2D
# =========================================================
# 2D図形描画.
# =========================================================

# ---------------------------------------------------------
# const.
# ---------------------------------------------------------
## 図形の種類.
enum eType {
	CIRCLE, # 正円.
	ELLIPSE, # 楕円.
	FILL_ARC, # 塗りつぶし円弧.
	RECT, # 矩形.
	ROUND_RECT, # 角丸矩形.
}

## 円.
const TBL_CIRCLE = [eType.CIRCLE, eType.ELLIPSE, eType.FILL_ARC]
## 矩形.
const TBL_RECT = [eType.RECT, eType.ROUND_RECT]

# ---------------------------------------------------------
# export.
# ---------------------------------------------------------
## 図形の種類.
@export var type = eType.CIRCLE
## 色.
@export var color = Color.WHITE
## 中央揃え.
@export var centered = true

## アウトライン
@export_group("Outline")
## アウトラインを有効にするかどうか.
@export var enabled_outline = false
## アウトラインの線の太さ.
@export_range(0.0, 64.0) var outline_width = 3.0
## アウトラインの色.
@export var outline_color = Color.DODGER_BLUE

## ------------ circle
@export_category("Circle/Ellipse")
## 半径.
@export_range(0.0, 512.0) var radius:float = 64.0
## 縦横の割合.
@export_range(0.0, 10.0) var radius_xratio:float = 1.0
@export_range(0.0, 10.0) var radius_yratio:float = 1.0
## ------------ fill arc
@export_category("Fill Arc")
## 開始角度.
@export_range(0.0, 360.0) var start:float = 0.0
## 広さ.
@export_range(0.0, 360.0) var arc:float = 45.0
@export_range(4, 256) var divide:int = 64
## ------------ rect
@export_category("Rect")
## 幅と高さ.
@export var size = Vector2(128.0, 64.0)
## ------------ round rect
@export_category("Round Rect")
@export_range(0.0, 1.0) var round_xratio:float = 0.1
@export_range(0.0, 1.0) var round_yratio:float = 0.2

# ---------------------------------------------------------
# public function.
# ---------------------------------------------------------
## 更新 (再描画の要求をする)
func update() -> void:
	queue_redraw()

# ---------------------------------------------------------
# private function.
# ---------------------------------------------------------
func _process(_delta: float) -> void:
	update()
	
func _draw() -> void:
	call("_draw_" + eType.keys()[type])

# ---------------------------------------------------------
# private draw function.
# ---------------------------------------------------------
## 基準の座標を取得する.
func _get_base_pos() -> Vector2:
	if type in TBL_CIRCLE:
		# 円の場合.
		if centered:
			return Vector2.ZERO 
		else:
			return Vector2(radius, radius)
	else:
		# 矩形の場合.
		if centered:
			return -(size/2)
		else:
			return Vector2.ZERO

## 円の描画.
func _draw_CIRCLE() -> void:
	var base = _get_base_pos()
	draw_circle(base, radius, color)
	
	if enabled_outline:
		# アウトラインの描画.
		draw_arc(base, radius, 0.0, 2*PI, divide, outline_color, outline_width)

## 楕円の描画.
func _draw_ELLIPSE() -> void:
	# 塗りつぶし用.
	var points = PackedVector2Array()
	var colors = PackedColorArray()
	# アウトライン用.
	var points2 = PackedVector2Array()
	
	var base = _get_base_pos()
	points.append(base)
	colors.append(color)
	var rad = 0.0
	var d = 2 * PI / (divide-1)
	for i in range(divide):
		var v = base
		v.x += (radius * radius_xratio) * cos(rad)
		v.y += (radius * radius_yratio) * sin(rad)
		points.append(v)
		colors.append(color)
		points2.append(v)
		rad += d
	draw_polygon(points, colors)
	
	if enabled_outline:
		# アウトラインの描画.
		draw_polyline(points2, outline_color, outline_width)

## 塗りつぶし円弧の描画.
func _draw_FILL_ARC() -> void:
	# 塗りつぶし用.
	var points = PackedVector2Array()
	var colors = PackedColorArray()
	# アウトライン用.
	var points2 = PackedVector2Array()
	
	var base = _get_base_pos()
	points.append(base)
	colors.append(color)
	var rad = deg_to_rad(start)
	var d = deg_to_rad(arc) / (divide - 1)
	for i in range(divide):
		var v = base
		v.x += radius * cos(rad)
		v.y += radius * sin(rad)
		points.append(v)
		colors.append(color)
		points2.append(v)
		rad += d
	draw_polygon(points, colors)
	
	if enabled_outline:
		# アウトラインの描画.
		draw_polyline(points2, outline_color, outline_width)

## 矩形の描画.
func _draw_RECT() -> void:
	var pos = _get_base_pos()
	var rect = Rect2(pos, size)
	draw_rect(rect, color)
	
	if enabled_outline:
		# アウトラインの描画.
		draw_rect(rect, outline_color, false, outline_width)

## 角丸矩形の描画.
func _draw_ROUND_RECT() -> void:
	# 2c 3b 3b 3b 2d
	# 3a 1  1  1  3a
	# 2b 3b 3b 3b 2a
	var base = _get_base_pos()
	var xrate = round_xratio/2
	var yrate = round_yratio/2
	
	# アウトライン用.
	var points2 = PackedVector2Array()
	
	# 1の部分を描画.
	var pos1 = base + Vector2(size.x * xrate, size.y * yrate)
	var size1 = Vector2()
	size1.x = size.x - (size.x * (xrate*2))
	size1.y = size.y - (size.y * (yrate*2))
	var rect1 = Rect2(pos1, size1)
	#draw_rect(rect1, color) # 3で描画するので不要.
	
	# 2[a-d]の部分を描画.
	var a = pos1 + size1
	var b = pos1 + Vector2(0, size1.y)
	var c = pos1
	var d = pos1 + Vector2(size1.x, 0)
	var idx = 0
	var size2 = Vector2()
	size2.x = size.x * xrate
	size2.y = size.y * yrate
	# 90度ずつ描画.
	var rad = 0.0
	var d_rad = (2 * PI / 4) / (divide-1)
	for pos2 in [a, b, c, d]:
		var points = PackedVector2Array()
		var colors = PackedColorArray()
		points.append(pos2)
		colors.append(color)
		for i in range(divide):
			var v = pos2
			v.x += size2.x * cos(rad)
			v.y += size2.y * sin(rad)
			points.append(v)
			colors.append(color)
			points2.append(v)
			
			rad += d_rad
		draw_polygon(points, colors)
		rad -= d_rad
	
	# 3aの部分を描画.
	var pos3a = Vector2(base.x, pos1.y)
	var size3a = Vector2(size.x, size1.y)
	var rect3a = Rect2(pos3a, size3a)
	draw_rect(rect3a, color)
	
	# 3bの部分を描画.
	# 左側.
	var pos3b1 = Vector2(pos1.x, base.y)
	var size3b1 = Vector2(size1.x, size2.y)
	var rect3b1 = Rect2(pos3b1, size3b1)
	draw_rect(rect3b1, color)
	
	# 右側.
	var pos3b2 = Vector2(pos1.x, pos1.y+size1.y)
	var size3b2 = Vector2(size1.x, size2.y)
	var rect3b2 = Rect2(pos3b2, size3b2)
	draw_rect(rect3b2, color)

	if enabled_outline:
		# 最初の点をつなぐ.
		var v = points2[0]
		points2.append(v)
		# アウトラインの描画.
		draw_polyline(points2, outline_color, outline_width)
