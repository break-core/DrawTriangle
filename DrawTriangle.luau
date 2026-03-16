--!strict
--[[
	public version of DrawTriangle for EditableImages (the roblox version isn't out yet)
	uses scanline rendering (like older OpenGL) which makes it really fast
	also supports image combine type which the original function (as of writing) didn't
]]
@native
local function DrawTriangle(
	editableImage: EditableImage, 
	p1: Vector2, 
	p2: Vector2, 
	p3: Vector2, 
	color: Color3, 
	transparency: number, 
	combineType: Enum.ImageCombineType
)
	local sz = editableImage.Size
	local pt = {p1, p2, p3}

	-- for loop for this might be a bit costly...
	for i = 1, 3 do
		local p = pt[i]

		assert(p.X >= 0 or p.Y >= 0, `DrawTriangle expects p{i} to be greater than or equal to 0`)
		assert(p.X < sz.X or p.Y < sz.Y, `DrawTriangle expects p{i} to be within EditableImage bounds`)
	end

	-- local copies of the points
	local v1, v2, v3 = p1, p2, p3

	-- sort locals by Y coord (v1 is top, v2 is mid, v3 is bottom)
	if v1.Y > v2.Y then v1, v2 = v2, v1 end
	if v1.Y > v3.Y then v1, v3 = v3, v1 end
	if v2.Y > v3.Y then v2, v3 = v3, v2 end

	-- scanline helper function
	@native
	local function scanline(y: number, xs: number, xe: number)
		local x1 = math.min(xs, xe)
		local x2 = math.max(xs, xe)
		local wd = math.ceil(x2 - x1)

		-- only draw a line when it actually can be visible
		if wd > 0 then
			editableImage:DrawRectangle(
				Vector2.new(x1, math.floor(y)),	-- position
				Vector2.new(wd, 1),				-- size
				color,
				transparency,
				combineType
			)
		end
	end

	local th = v3.Y - v1.Y

	-- no drawing tris if the lowest and highest point have no height difference
	if th == 0 then return end

	local ht = v2.Y - v1.Y
	local hb = v3.Y - v2.Y

	-- top half
	for i = 0, ht - 1 do
		local y = v1.Y + i
		local f1 = i / th
		local f2 = i / ht

		local xs = v1.X + (v3.X - v1.X) * f1
		local xe = v1.X + (v2.X - v1.X) * f2

		scanline(y, xs, xe)
	end

	-- bottom half
	for i = 0, hb do
		local y = v2.Y + i
		local f1 = (i + ht) / th
		local f2 = if hb ~= 0 then i / hb else 0

		local xs = v1.X + (v3.X - v1.X) * f1
		local xe = v2.X + (v3.X - v2.X) * f2

		scanline(y, xs, xe)
	end
end