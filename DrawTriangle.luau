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
		local wd = math.floor(x2 - x1)

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

	-- calculations for how to draw a line
	-- a scanline is drawn once each time until the difference of v3 - v1
	for i = 0, th do
		local y = v1.Y + i
		local f = i / th
		local xs = v1.X + (v3.X - v1.X) * f
		local xe = 0

		if i < (v2.Y - v1.Y) then
			-- v1 -> v2 interp
			local h = v2.Y - v1.Y
			if h ~= 0 then
				local t = i / h
				xe = v1.X + (v2.X - v1.X) * t
			end
		else
			-- v2 -> v3 interp
			local h = v3.Y - v2.Y
			if h ~= 0 then
				local t = (i - (v2.Y - v1.Y)) / h
				xe = v2.X + (v3.X - v2.X) * t
			end
		end

		-- draw a line!!
		scanline(y, xs, xe)
	end
end