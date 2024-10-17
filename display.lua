local VERSION = C_AddOns.GetAddOnMetadata(..., "Version")
local TITAN_PLUGIN = "BuildDisplay"
local TITAN_BUTTON = "TitanPanel" .. TITAN_PLUGIN .. "Button"

local function GetButtonText()
  -- spec
  -- hero talent
  -- loadout
  -- TitanGetVar(TITAN_PLUGIN, "ShowColoredText")

  return "Build: ", "BUILD INFORMATION HERE" -- FIXME
end

local function CreatePlugin()
  if _G[TITAN_BUTTON] then
    return
  end

  local frame = CreateFrame("Frame", nil, UIParent)
  local window = CreateFrame("Button", TITAN_BUTTON, frame, "TitanPanelTextTemplate")

  window.registry = {
    id = TITAN_PLUGIN,
    category = "Information",
    version = VERSION,
    menuText = "Build Information",
--    menuTextFunction = CreateMenu,
    buttonTextFunction = GetButtonText,
    tooltipTitle = "Build Information",
--    tooltipTextFunction = GetTooltipText,
    notes = "Display the current spec, build, and hero talents.",
    controlVariables = {
      ShowIcon = false,
      ShowLabelText = true,
--      ShowColoredText = true,
      DisplayOnRightSide = false,
    },
    savedVariables = {
    }
  }

  window:SetFrameStrata("FULLSCREEN")

  window:SetScript("OnShow", function(self)
    self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
  end)

  window:SetScript("OnHide", function(self)
    self:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
  end)

  window:SetScript("OnEvent", function(self, event, ...)
    local args = ...

    if args[1] == "player" and args[3] == 384255 then
      TitanPanelButton_UpdateButton(TITAN_PLUGIN)
    end
  end)

  window:SetScript("OnClick", function(self, button)
    -- open talent menu?
    TitanPanelButton_OnClick(self, button)
  end)
end

CreatePlugin()
