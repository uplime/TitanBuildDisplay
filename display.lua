local VERSION = C_AddOns.GetAddOnMetadata(..., "Version")
local TITAN_PLUGIN = "BuildDisplay"
local TITAN_BUTTON = "TitanPanel" .. TITAN_PLUGIN .. "Button"

local function GetButtonText()
  -- hero talent
  -- loadout

  local build_info = { }
  local spec_id = GetSpecialization()

  if spec_id then
    local spec_name = GetSpecializationInfo(spec_id)
    table.insert(build_info, spec_name)
  end

  local config_id = C_ClassTalents.GetActiveConfigID()
  local hero_tree_id = C_ClassTalents.GetActiveHeroTalentSpec()
  local hero_tree = C_Traits.GetSubTreeInfo(config_id, hero_tree_id)

  DevTools_Dump(hero_tree)

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
    self:RegisterEvent("TRAIT_CONFIG_UPDATED")
  end)

  window:SetScript("OnHide", function(self)
    self:UnregisterEvent("TRAIT_CONFIG_UPDATED")
  end)

  window:SetScript("OnEvent", function(self, event, ...)
    if event == "TRAIT_CONFIG_UPDATED" then
      TitanPanelButton_UpdateButton(TITAN_PLUGIN)
    end
  end)

  window:SetScript("OnClick", function(self, button)
    -- open talent menu?
    TitanPanelButton_OnClick(self, button)
  end)
end

CreatePlugin()
