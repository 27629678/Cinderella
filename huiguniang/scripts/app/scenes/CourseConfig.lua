local buyingtip = import("..views.BuyingTipsView")
local alertview = import("..views.AlertView")

local CourseConfig = class("CourseConfig", function ()
	return display.newScene("CourseConfig")
end)

function CourseConfig:ctor()

	-- const data config
	self.courseconfigstate = true
	self.isPayed = GameData.BuyState == "TRUE" and true or false
	self.isMainAppInstall = true

	self.multibutton_nor = "CourseConfig/Multi-SelectButton_Nor.png"
	self.multibutton_hig = "CourseConfig/Multi-SelectButton_Hig.png"
	self.multibutton_dis = "CourseConfig/Multi-SelectButton_Disable.png"

	self.radiobutton_nor = "CourseConfig/RadioButton_Nor.png"
	self.radiobutton_hig = "CourseConfig/RadioButton_Hig.png"
	
	-- 默认Layer
	self.layer = display.newLayer()

	-- background
	display.newSprite("CourseConfig/Background.jpg", display.cx, display.cy):addTo(self.layer):setScaleX(display.width/1024)

	local function onButtonClicked(tag)
		app:enterMainMenuScene()
	end

	-- return button
	local returnbutton = ui.newImageMenuItem({
			image = "About/Button_Return.png",
		    imageSelected = "About/Button_Return.png",
			listener = onButtonClicked,
			x = display.left + 85,
		    y = display.top - 38
		})

	local featuredbutton = ui.newImageMenuItem({
			image = self.radiobutton_nor,
		    imageSelected = self.radiobutton_nor,
			listener = function (tag)
				self:onFeaturedButtonClickAction(tag)
			end,
			x = 80,
		    y = 648
		})

	local recommendedbutton = ui.newImageMenuItem({
			image = self.radiobutton_nor,
		    imageSelected = self.radiobutton_nor,
			listener = function (tag)
				self:onRecommendedButtonClickAction(tag)
			end,
			x = 80,
		    y = 210
		})

	local freebutton_1 = ui.newImageMenuItem({
			image = self.multibutton_nor,
		    imageSelected = self.multibutton_nor,
			listener = nil,
			x = 110,
		    y = 610
		})

	local unfreebutton_1 = ui.newImageMenuItem({
			image = self.multibutton_nor,
		    imageSelected = self.multibutton_nor,
			listener = function (tag)
				self:onBuyButtonClickAction(tag)
			end,
			x = 110,
		    y = 410
		})

	local freebutton_2 = ui.newImageMenuItem({
			image = self.multibutton_nor,
		    imageSelected = self.multibutton_nor,
			listener = nil,
			x = 110,
		    y = 170
		})

	self.menu = ui.newMenu({returnbutton, featuredbutton, recommendedbutton, freebutton_2, freebutton_1, unfreebutton_1}):addTo(self.layer)

	-- 单选按钮
	self.featuredbuttonicon = display.newSprite(self.radiobutton_hig, 80, 648)
	self.layer:addChild(self.featuredbuttonicon)

	self.recommendedbuttonicon = display.newSprite(self.radiobutton_nor, 80, 210)
	self.layer:addChild(self.recommendedbuttonicon)

	self.freebuttonicon_1 = display.newSprite(self.multibutton_hig, 110, 610)
	self.layer:addChild(self.freebuttonicon_1)

	local imagename = self.multibutton_nor
	if self.isPayed == true then
		imagename = self.multibutton_hig
	else
		imagename = self.multibutton_nor
	end
	self.unfreebuttonicon_1 = display.newSprite(imagename, 110, 410)
	self.layer:addChild(self.unfreebuttonicon_1)

	self.freebuttonicon_2 = display.newSprite(self.multibutton_hig, 110, 170)
	self.layer:addChild(self.freebuttonicon_2)

	self:switchButtonIcon(self.courseconfigstate)

	self:addChild(self.layer)
end

function CourseConfig:onFeaturedButtonClickAction(tag)
	if self.courseconfigstate == true then return end
	
	alertview:show({
				parent 	= self,
				title 	= "是否要取消与网易识字的课程同步",
				content = "取消同步后，网易识字将不再通过该故事复习汉字",
				button1 = 	{
								title 	 = "取消",
								callback = nil
							},
				button2 = 	{
								title 	 = "确定",
								callback = function (tag)
									alertview:show({
										parent 	= self,
										title 	= "取消同步成功",
										content = "网易识字将不再通过该故事复习汉字",
										button1 = 	{
														title 	 = "确定",
														callback = function (tag)
															self.courseconfigstate = true
															self:switchButtonIcon(true)
														end
													}
									})
								end
							}
			})
end

function CourseConfig:onRecommendedButtonClickAction(tag)
	if self.courseconfigstate == false then return end

	if self.isMainAppInstall ~= true then
		alertview:show({
				parent 	= self,
				title 	= "请下载网易识字后同步",
				content = nil,
				button1 = 	{
								title 	 = "取消",
								callback = nil
							},
				button2 = 	{
								title 	 = "去下载",
								callback = function (tag)
									self:DownloadMainApp()
								end
							}
			})

		return
	end

	self.courseconfigstate = false
	self:switchButtonIcon(false)

	self:SyncLearnPlan()
end

function CourseConfig:DownloadMainApp()
	print "打开App Store，进行下载操作"
end

function CourseConfig:SyncLearnPlan()
	print "Sync Learn Plan."

	alertview:show({
			parent 	= self,
			title 	= "课程进度同步成功",
			content = nil,
			button1 = 	{
							title 	 = "确定",
							callback = nil
						}
		})
end

function CourseConfig:registAlertViewDelegate()
	local callback = function(state) self:EnableUpLayerTouchEvent(state) end

	return callback
end

function CourseConfig:onBuyButtonClickAction(tag)
	if self.isPayed == true or self.courseconfigstate == false then
		return
	end

	-- print "go to store......"
	buyingtip:create(self, self:registAlertViewDelegate())
end

function CourseConfig:EnableUpLayerTouchEvent(state)
	self.layer:setTouchEnabled(state)
	self.menu:setEnabled(state)
end

function CourseConfig:switchButtonIcon(state)
	if state == true then
		local imagename = self.multibutton_nor
		if self.isPayed == true then
			imagename = self.multibutton_hig
		else
			imagename = self.multibutton_nor
		end
		setButtonSprite(self.featuredbuttonicon, self.radiobutton_hig)
		setButtonSprite(self.freebuttonicon_1, self.multibutton_hig)
		setButtonSprite(self.unfreebuttonicon_1, imagename)

		setButtonSprite(self.recommendedbuttonicon, self.radiobutton_nor)
		setButtonSprite(self.freebuttonicon_2, self.multibutton_dis)

	else
		local imagename = self.multibutton_nor
		if self.isPayed == true then
			imagename = self.multibutton_dis
		else
			imagename = self.multibutton_nor
		end
		setButtonSprite(self.featuredbuttonicon, self.radiobutton_nor)
		setButtonSprite(self.freebuttonicon_1, self.multibutton_dis)
		setButtonSprite(self.unfreebuttonicon_1, imagename)

		setButtonSprite(self.recommendedbuttonicon, self.radiobutton_hig)
		setButtonSprite(self.freebuttonicon_2, self.multibutton_hig)
	end
end

function setButtonSprite(target, file) target:setTexture(CCTextureCache:sharedTextureCache():addImage(file)) end

return CourseConfig