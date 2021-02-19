$sCLSID_UIAutomationClient="{944DE083-8FB8-45CF-BCB7-C477ACB2F897}"
$CLSID_UIAutomationClient=_AutoItObject_CLSIDFromString($sCLSID_UIAutomationClient)
;===============================================================================
;CoClasses
$sCLSID_CUIAutomation="{FF48DBA4-60EF-4201-AA87-54103EEF594E}"
$CLSID_CUIAutomation=_AutoItObject_CLSIDFromString($sCLSID_CUIAutomation)
;===============================================================================
;module UIA_PatternIds
;===============================================================================
Global Const $UIA_InvokePatternId=10000
Global Const $UIA_SelectionPatternId=10001
Global Const $UIA_ValuePatternId=10002
Global Const $UIA_RangeValuePatternId=10003
Global Const $UIA_ScrollPatternId=10004
Global Const $UIA_ExpandCollapsePatternId=10005
Global Const $UIA_GridPatternId=10006
Global Const $UIA_GridItemPatternId=10007
Global Const $UIA_MultipleViewPatternId=10008
Global Const $UIA_WindowPatternId=10009
Global Const $UIA_SelectionItemPatternId=10010
Global Const $UIA_DockPatternId=10011
Global Const $UIA_TablePatternId=10012
Global Const $UIA_TableItemPatternId=10013
Global Const $UIA_TextPatternId=10014
Global Const $UIA_TogglePatternId=10015
Global Const $UIA_TransformPatternId=10016
Global Const $UIA_ScrollItemPatternId=10017
Global Const $UIA_LegacyIAccessiblePatternId=10018
Global Const $UIA_ItemContainerPatternId=10019
Global Const $UIA_VirtualizedItemPatternId=10020
Global Const $UIA_SynchronizedInputPatternId=10021

;module UIA_EventIds
;===============================================================================
Global Const $UIA_ToolTipOpenedEventId=20000
Global Const $UIA_ToolTipClosedEventId=20001
Global Const $UIA_StructureChangedEventId=20002
Global Const $UIA_MenuOpenedEventId=20003
Global Const $UIA_AutomationPropertyChangedEventId=20004
Global Const $UIA_AutomationFocusChangedEventId=20005
Global Const $UIA_AsyncContentLoadedEventId=20006
Global Const $UIA_MenuClosedEventId=20007
Global Const $UIA_LayoutInvalidatedEventId=20008
Global Const $UIA_Invoke_InvokedEventId=20009
Global Const $UIA_SelectionItem_ElementAddedToSelectionEventId=20010
Global Const $UIA_SelectionItem_ElementRemovedFromSelectionEventId=20011
Global Const $UIA_SelectionItem_ElementSelectedEventId=20012
Global Const $UIA_Selection_InvalidatedEventId=20013
Global Const $UIA_Text_TextSelectionChangedEventId=20014
Global Const $UIA_Text_TextChangedEventId=20015
Global Const $UIA_Window_WindowOpenedEventId=20016
Global Const $UIA_Window_WindowClosedEventId=20017
Global Const $UIA_MenuModeStartEventId=20018
Global Const $UIA_MenuModeEndEventId=20019
Global Const $UIA_InputReachedTargetEventId=20020
Global Const $UIA_InputReachedOtherElementEventId=20021
Global Const $UIA_InputDiscardedEventId=20022

;module UIA_PropertyIds
;===============================================================================
Global Const $UIA_RuntimeIdPropertyId=30000
Global Const $UIA_BoundingRectanglePropertyId=30001
Global Const $UIA_ProcessIdPropertyId=30002
Global Const $UIA_ControlTypePropertyId=30003
Global Const $UIA_LocalizedControlTypePropertyId=30004
Global Const $UIA_NamePropertyId=30005
Global Const $UIA_AcceleratorKeyPropertyId=30006
Global Const $UIA_AccessKeyPropertyId=30007
Global Const $UIA_HasKeyboardFocusPropertyId=30008
Global Const $UIA_IsKeyboardFocusablePropertyId=30009
Global Const $UIA_IsEnabledPropertyId=30010
Global Const $UIA_AutomationIdPropertyId=30011
Global Const $UIA_ClassNamePropertyId=30012
Global Const $UIA_HelpTextPropertyId=30013
Global Const $UIA_ClickablePointPropertyId=30014
Global Const $UIA_CulturePropertyId=30015
Global Const $UIA_IsControlElementPropertyId=30016
Global Const $UIA_IsContentElementPropertyId=30017
Global Const $UIA_LabeledByPropertyId=30018
Global Const $UIA_IsPasswordPropertyId=30019
Global Const $UIA_NativeWindowHandlePropertyId=30020
Global Const $UIA_ItemTypePropertyId=30021
Global Const $UIA_IsOffscreenPropertyId=30022
Global Const $UIA_OrientationPropertyId=30023
Global Const $UIA_FrameworkIdPropertyId=30024
Global Const $UIA_IsRequiredForFormPropertyId=30025
Global Const $UIA_ItemStatusPropertyId=30026
Global Const $UIA_IsDockPatternAvailablePropertyId=30027
Global Const $UIA_IsExpandCollapsePatternAvailablePropertyId=30028
Global Const $UIA_IsGridItemPatternAvailablePropertyId=30029
Global Const $UIA_IsGridPatternAvailablePropertyId=30030
Global Const $UIA_IsInvokePatternAvailablePropertyId=30031
Global Const $UIA_IsMultipleViewPatternAvailablePropertyId=30032
Global Const $UIA_IsRangeValuePatternAvailablePropertyId=30033
Global Const $UIA_IsScrollPatternAvailablePropertyId=30034
Global Const $UIA_IsScrollItemPatternAvailablePropertyId=30035
Global Const $UIA_IsSelectionItemPatternAvailablePropertyId=30036
Global Const $UIA_IsSelectionPatternAvailablePropertyId=30037
Global Const $UIA_IsTablePatternAvailablePropertyId=30038
Global Const $UIA_IsTableItemPatternAvailablePropertyId=30039
Global Const $UIA_IsTextPatternAvailablePropertyId=30040
Global Const $UIA_IsTogglePatternAvailablePropertyId=30041
Global Const $UIA_IsTransformPatternAvailablePropertyId=30042
Global Const $UIA_IsValuePatternAvailablePropertyId=30043
Global Const $UIA_IsWindowPatternAvailablePropertyId=30044
Global Const $UIA_ValueValuePropertyId=30045
Global Const $UIA_ValueIsReadOnlyPropertyId=30046
Global Const $UIA_RangeValueValuePropertyId=30047
Global Const $UIA_RangeValueIsReadOnlyPropertyId=30048
Global Const $UIA_RangeValueMinimumPropertyId=30049
Global Const $UIA_RangeValueMaximumPropertyId=30050
Global Const $UIA_RangeValueLargeChangePropertyId=30051
Global Const $UIA_RangeValueSmallChangePropertyId=30052
Global Const $UIA_ScrollHorizontalScrollPercentPropertyId=30053
Global Const $UIA_ScrollHorizontalViewSizePropertyId=30054
Global Const $UIA_ScrollVerticalScrollPercentPropertyId=30055
Global Const $UIA_ScrollVerticalViewSizePropertyId=30056
Global Const $UIA_ScrollHorizontallyScrollablePropertyId=30057
Global Const $UIA_ScrollVerticallyScrollablePropertyId=30058
Global Const $UIA_SelectionSelectionPropertyId=30059
Global Const $UIA_SelectionCanSelectMultiplePropertyId=30060
Global Const $UIA_SelectionIsSelectionRequiredPropertyId=30061
Global Const $UIA_GridRowCountPropertyId=30062
Global Const $UIA_GridColumnCountPropertyId=30063
Global Const $UIA_GridItemRowPropertyId=30064
Global Const $UIA_GridItemColumnPropertyId=30065
Global Const $UIA_GridItemRowSpanPropertyId=30066
Global Const $UIA_GridItemColumnSpanPropertyId=30067
Global Const $UIA_GridItemContainingGridPropertyId=30068
Global Const $UIA_DockDockPositionPropertyId=30069
Global Const $UIA_ExpandCollapseExpandCollapseStatePropertyId=30070
Global Const $UIA_MultipleViewCurrentViewPropertyId=30071
Global Const $UIA_MultipleViewSupportedViewsPropertyId=30072
Global Const $UIA_WindowCanMaximizePropertyId=30073
Global Const $UIA_WindowCanMinimizePropertyId=30074
Global Const $UIA_WindowWindowVisualStatePropertyId=30075
Global Const $UIA_WindowWindowInteractionStatePropertyId=30076
Global Const $UIA_WindowIsModalPropertyId=30077
Global Const $UIA_WindowIsTopmostPropertyId=30078
Global Const $UIA_SelectionItemIsSelectedPropertyId=30079
Global Const $UIA_SelectionItemSelectionContainerPropertyId=30080
Global Const $UIA_TableRowHeadersPropertyId=30081
Global Const $UIA_TableColumnHeadersPropertyId=30082
Global Const $UIA_TableRowOrColumnMajorPropertyId=30083
Global Const $UIA_TableItemRowHeaderItemsPropertyId=30084
Global Const $UIA_TableItemColumnHeaderItemsPropertyId=30085
Global Const $UIA_ToggleToggleStatePropertyId=30086
Global Const $UIA_TransformCanMovePropertyId=30087
Global Const $UIA_TransformCanResizePropertyId=30088
Global Const $UIA_TransformCanRotatePropertyId=30089
Global Const $UIA_IsLegacyIAccessiblePatternAvailablePropertyId=30090
Global Const $UIA_LegacyIAccessibleChildIdPropertyId=30091
Global Const $UIA_LegacyIAccessibleNamePropertyId=30092
Global Const $UIA_LegacyIAccessibleValuePropertyId=30093
Global Const $UIA_LegacyIAccessibleDescriptionPropertyId=30094
Global Const $UIA_LegacyIAccessibleRolePropertyId=30095
Global Const $UIA_LegacyIAccessibleStatePropertyId=30096
Global Const $UIA_LegacyIAccessibleHelpPropertyId=30097
Global Const $UIA_LegacyIAccessibleKeyboardShortcutPropertyId=30098
Global Const $UIA_LegacyIAccessibleSelectionPropertyId=30099
Global Const $UIA_LegacyIAccessibleDefaultActionPropertyId=30100
Global Const $UIA_AriaRolePropertyId=30101
Global Const $UIA_AriaPropertiesPropertyId=30102
Global Const $UIA_IsDataValidForFormPropertyId=30103
Global Const $UIA_ControllerForPropertyId=30104
Global Const $UIA_DescribedByPropertyId=30105
Global Const $UIA_FlowsToPropertyId=30106
Global Const $UIA_ProviderDescriptionPropertyId=30107
Global Const $UIA_IsItemContainerPatternAvailablePropertyId=30108
Global Const $UIA_IsVirtualizedItemPatternAvailablePropertyId=30109
Global Const $UIA_IsSynchronizedInputPatternAvailablePropertyId=30110

;module UIA_TextAttributeIds
;===============================================================================
Global Const $UIA_AnimationStyleAttributeId=40000
Global Const $UIA_BackgroundColorAttributeId=40001
Global Const $UIA_BulletStyleAttributeId=40002
Global Const $UIA_CapStyleAttributeId=40003
Global Const $UIA_CultureAttributeId=40004
Global Const $UIA_FontNameAttributeId=40005
Global Const $UIA_FontSizeAttributeId=40006
Global Const $UIA_FontWeightAttributeId=40007
Global Const $UIA_ForegroundColorAttributeId=40008
Global Const $UIA_HorizontalTextAlignmentAttributeId=40009
Global Const $UIA_IndentationFirstLineAttributeId=40010
Global Const $UIA_IndentationLeadingAttributeId=40011
Global Const $UIA_IndentationTrailingAttributeId=40012
Global Const $UIA_IsHiddenAttributeId=40013
Global Const $UIA_IsItalicAttributeId=40014
Global Const $UIA_IsReadOnlyAttributeId=40015
Global Const $UIA_IsSubscriptAttributeId=40016
Global Const $UIA_IsSuperscriptAttributeId=40017
Global Const $UIA_MarginBottomAttributeId=40018
Global Const $UIA_MarginLeadingAttributeId=40019
Global Const $UIA_MarginTopAttributeId=40020
Global Const $UIA_MarginTrailingAttributeId=40021
Global Const $UIA_OutlineStylesAttributeId=40022
Global Const $UIA_OverlineColorAttributeId=40023
Global Const $UIA_OverlineStyleAttributeId=40024
Global Const $UIA_StrikethroughColorAttributeId=40025
Global Const $UIA_StrikethroughStyleAttributeId=40026
Global Const $UIA_TabsAttributeId=40027
Global Const $UIA_TextFlowDirectionsAttributeId=40028
Global Const $UIA_UnderlineColorAttributeId=40029
Global Const $UIA_UnderlineStyleAttributeId=40030

;module UIA_ControlTypeIds
;===============================================================================
Global Const $UIA_ButtonControlTypeId=50000
Global Const $UIA_CalendarControlTypeId=50001
Global Const $UIA_CheckBoxControlTypeId=50002
Global Const $UIA_ComboBoxControlTypeId=50003
Global Const $UIA_EditControlTypeId=50004
Global Const $UIA_HyperlinkControlTypeId=50005
Global Const $UIA_ImageControlTypeId=50006
Global Const $UIA_ListItemControlTypeId=50007
Global Const $UIA_ListControlTypeId=50008
Global Const $UIA_MenuControlTypeId=50009
Global Const $UIA_MenuBarControlTypeId=50010
Global Const $UIA_MenuItemControlTypeId=50011
Global Const $UIA_ProgressBarControlTypeId=50012
Global Const $UIA_RadioButtonControlTypeId=50013
Global Const $UIA_ScrollBarControlTypeId=50014
Global Const $UIA_SliderControlTypeId=50015
Global Const $UIA_SpinnerControlTypeId=50016
Global Const $UIA_StatusBarControlTypeId=50017
Global Const $UIA_TabControlTypeId=50018
Global Const $UIA_TabItemControlTypeId=50019
Global Const $UIA_TextControlTypeId=50020
Global Const $UIA_ToolBarControlTypeId=50021
Global Const $UIA_ToolTipControlTypeId=50022
Global Const $UIA_TreeControlTypeId=50023
Global Const $UIA_TreeItemControlTypeId=50024
Global Const $UIA_CustomControlTypeId=50025
Global Const $UIA_GroupControlTypeId=50026
Global Const $UIA_ThumbControlTypeId=50027
Global Const $UIA_DataGridControlTypeId=50028
Global Const $UIA_DataItemControlTypeId=50029
Global Const $UIA_DocumentControlTypeId=50030
Global Const $UIA_SplitButtonControlTypeId=50031
Global Const $UIA_WindowControlTypeId=50032
Global Const $UIA_PaneControlTypeId=50033
Global Const $UIA_HeaderControlTypeId=50034
Global Const $UIA_HeaderItemControlTypeId=50035
Global Const $UIA_TableControlTypeId=50036
Global Const $UIA_TitleBarControlTypeId=50037
Global Const $UIA_SeparatorControlTypeId=50038

;enum TreeScope
;===============================================================================
Global Const $TreeScope_Element=1
Global Const $TreeScope_Children=2
Global Const $TreeScope_Descendants=4
Global Const $TreeScope_Parent=8
Global Const $TreeScope_Ancestors=16
Global Const $TreeScope_Subtree=7

;enum AutomationElementMode
;===============================================================================
Global Const $AutomationElementMode_None=0
Global Const $AutomationElementMode_Full=1

;enum OrientationType
;===============================================================================
Global Const $OrientationType_None=0
Global Const $OrientationType_Horizontal=1
Global Const $OrientationType_Vertical=2

;enum PropertyConditionFlags
;===============================================================================
Global Const $PropertyConditionFlags_None=0
Global Const $PropertyConditionFlags_IgnoreCase=1

;enum StructureChangeType
;===============================================================================
Global Const $StructureChangeType_ChildAdded=0
Global Const $StructureChangeType_ChildRemoved=1
Global Const $StructureChangeType_ChildrenInvalidated=2
Global Const $StructureChangeType_ChildrenBulkAdded=3
Global Const $StructureChangeType_ChildrenBulkRemoved=4
Global Const $StructureChangeType_ChildrenReordered=5

;enum DockPosition
;===============================================================================
Global Const $DockPosition_Top=0
Global Const $DockPosition_Left=1
Global Const $DockPosition_Bottom=2
Global Const $DockPosition_Right=3
Global Const $DockPosition_Fill=4
Global Const $DockPosition_None=5

;enum ExpandCollapseState
;===============================================================================
Global Const $ExpandCollapseState_Collapsed=0
Global Const $ExpandCollapseState_Expanded=1
Global Const $ExpandCollapseState_PartiallyExpanded=2
Global Const $ExpandCollapseState_LeafNode=3

;enum ScrollAmount
;===============================================================================
Global Const $ScrollAmount_LargeDecrement=0
Global Const $ScrollAmount_SmallDecrement=1
Global Const $ScrollAmount_NoAmount=2
Global Const $ScrollAmount_LargeIncrement=3
Global Const $ScrollAmount_SmallIncrement=4

;enum SynchronizedInputType
;===============================================================================
Global Const $SynchronizedInputType_KeyUp=1
Global Const $SynchronizedInputType_KeyDown=2
Global Const $SynchronizedInputType_LeftMouseUp=4
Global Const $SynchronizedInputType_LeftMouseDown=8
Global Const $SynchronizedInputType_RightMouseUp=16
Global Const $SynchronizedInputType_RightMouseDown=32

;enum RowOrColumnMajor
;===============================================================================
Global Const $RowOrColumnMajor_RowMajor=0
Global Const $RowOrColumnMajor_ColumnMajor=1
Global Const $RowOrColumnMajor_Indeterminate=2

;enum ToggleState
;===============================================================================
Global Const $ToggleState_Off=0
Global Const $ToggleState_On=1
Global Const $ToggleState_Indeterminate=2

;enum WindowVisualState
;===============================================================================
Global Const $WindowVisualState_Normal=0
Global Const $WindowVisualState_Maximized=1
Global Const $WindowVisualState_Minimized=2

;enum WindowInteractionState
;===============================================================================
Global Const $WindowInteractionState_Running=0
Global Const $WindowInteractionState_Closing=1
Global Const $WindowInteractionState_ReadyForUserInteraction=2
Global Const $WindowInteractionState_BlockedByModalWindow=3
Global Const $WindowInteractionState_NotResponding=4

;enum TextPatternRangeEndpoint
;===============================================================================
Global Const $TextPatternRangeEndpoint_Start=0
Global Const $TextPatternRangeEndpoint_End=1

;enum TextUnit
;===============================================================================
Global Const $TextUnit_Character=0
Global Const $TextUnit_Format=1
Global Const $TextUnit_Word=2
Global Const $TextUnit_Line=3
Global Const $TextUnit_Paragraph=4
Global Const $TextUnit_Page=5
Global Const $TextUnit_Document=6

;enum SupportedTextSelection
;===============================================================================
Global Const $SupportedTextSelection_None=0
Global Const $SupportedTextSelection_Single=1
Global Const $SupportedTextSelection_Multiple=2

;enum ProviderOptions
;===============================================================================
Global Const $ProviderOptions_ClientSideProvider=1
Global Const $ProviderOptions_ServerSideProvider=2
Global Const $ProviderOptions_NonClientAreaProvider=4
Global Const $ProviderOptions_OverrideProvider=8
Global Const $ProviderOptions_ProviderOwnsSetFocus=16
Global Const $ProviderOptions_UseComThreading=32


Global Const $sIID_IUIAutomationElement="{D22108AA-8AC5-49A5-837B-37BBB3D7591E}"
Global Const $cIID_IUIAutomationElement=_AutoItObject_CLSIDFromString($sIID_IUIAutomationElement)
Global $dtagIUIAutomationElement = $dtagIUnknown & _
"SetFocus hresult();" & _ ;SetFocus hresult()
"GetRuntimeId hresult(ptr*);" & _ ;GetRuntimeId hresult([out] ne )
"FindFirst hresult(long;ptr;ptr*);" & _ ;FindFirst hresult([in] TreeScope ;[in] IUIAutomationCondition *;[out] IUIAutomationElement **)
"FindAll hresult(long;ptr;ptr*);" & _ ;FindAll hresult([in] TreeScope ;[in] IUIAutomationCondition *;[out] IUIAutomationElementArray **)
"FindFirstBuildCache hresult(long;ptr;ptr;ptr*);" & _ ;FindFirstBuildCache hresult([in] TreeScope ;[in] IUIAutomationCondition *;[in] IUIAutomationCacheRequest *;[out] IUIAutomationElement **)
"FindAllBuildCache hresult(long;ptr;ptr;ptr*);" & _ ;FindAllBuildCache hresult([in] TreeScope ;[in] IUIAutomationCondition *;[in] IUIAutomationCacheRequest *;[out] IUIAutomationElementArray **)
"BuildUpdatedCache hresult(ptr;ptr*);" & _ ;BuildUpdatedCache hresult([in] IUIAutomationCacheRequest *;[out] IUIAutomationElement **)
"GetCurrentPropertyValue hresult(int;variant*);" & _ ;GetCurrentPropertyValue hresult([in] int ;[out] variant )
"GetCurrentPropertyValueEx hresult(int;long;variant*);" & _ ;GetCurrentPropertyValueEx hresult([in] int ;[in] int ;[out] variant )
"GetCachedPropertyValue hresult(int;variant*);" & _ ;GetCachedPropertyValue hresult([in] int ;[out] variant )
"GetCachedPropertyValueEx hresult(int;long;variant*);" & _ ;GetCachedPropertyValueEx hresult([in] int ;[in] int ;[out] variant )
"GetCurrentPatternAs hresult(int;none;none*);" & _ ;GetCurrentPatternAs hresult([in] int ;[in] GUID *;[out] void )
"GetCachedPatternAs hresult(int;none;none*);" & _ ;GetCachedPatternAs hresult([in] int ;[in] GUID *;[out] void )
"GetCurrentPattern hresult(int;ptr*);" & _ ;GetCurrentPattern hresult([in] int ;[out] iunknown )
"GetCachedPattern hresult(int;ptr*);" & _ ;GetCachedPattern hresult([in] int ;[out] iunknown )
"GetCachedParent hresult(ptr*);" & _ ;GetCachedParent hresult([out] IUIAutomationElement **)
"GetCachedChildren hresult(ptr*);" & _ ;GetCachedChildren hresult([out] IUIAutomationElementArray **)
"CurrentProcessId hresult(int*);" & _ ;CurrentProcessId hresult([out] int )
"CurrentControlType hresult(int*);" & _ ;CurrentControlType hresult([out] int )
"CurrentLocalizedControlType hresult(bstr*);" & _ ;CurrentLocalizedControlType hresult([out] bstr )
"CurrentName hresult(bstr*);" & _ ;CurrentName hresult([out] bstr )
"CurrentAcceleratorKey hresult(bstr*);" & _ ;CurrentAcceleratorKey hresult([out] bstr )
"CurrentAccessKey hresult(bstr*);" & _ ;CurrentAccessKey hresult([out] bstr )
"CurrentHasKeyboardFocus hresult(long*);" & _ ;CurrentHasKeyboardFocus hresult([out] int )
"CurrentIsKeyboardFocusable hresult(long*);" & _ ;CurrentIsKeyboardFocusable hresult([out] int )
"CurrentIsEnabled hresult(long*);" & _ ;CurrentIsEnabled hresult([out] int )
"CurrentAutomationId hresult(bstr*);" & _ ;CurrentAutomationId hresult([out] bstr )
"CurrentClassName hresult(bstr*);" & _ ;CurrentClassName hresult([out] bstr )
"CurrentHelpText hresult(bstr*);" & _ ;CurrentHelpText hresult([out] bstr )
"CurrentCulture hresult(int*);" & _ ;CurrentCulture hresult([out] int )
"CurrentIsControlElement hresult(long*);" & _ ;CurrentIsControlElement hresult([out] int )
"CurrentIsContentElement hresult(long*);" & _ ;CurrentIsContentElement hresult([out] int )
"CurrentIsPassword hresult(long*);" & _ ;CurrentIsPassword hresult([out] int )
"CurrentNativeWindowHandle hresult(none*);" & _ ;CurrentNativeWindowHandle hresult([out] void )
"CurrentItemType hresult(bstr*);" & _ ;CurrentItemType hresult([out] bstr )
"CurrentIsOffscreen hresult(long*);" & _ ;CurrentIsOffscreen hresult([out] int )
"CurrentOrientation hresult(long*);" & _ ;CurrentOrientation hresult([out] OrientationType *)
"CurrentFrameworkId hresult(bstr*);" & _ ;CurrentFrameworkId hresult([out] bstr )
"CurrentIsRequiredForForm hresult(long*);" & _ ;CurrentIsRequiredForForm hresult([out] int )
"CurrentItemStatus hresult(bstr*);" & _ ;CurrentItemStatus hresult([out] bstr )
"CurrentBoundingRectangle hresult(none*);" & _ ;CurrentBoundingRectangle hresult([out] tagRECT *)
"CurrentLabeledBy hresult(ptr*);" & _ ;CurrentLabeledBy hresult([out] IUIAutomationElement **)
"CurrentAriaRole hresult(bstr*);" & _ ;CurrentAriaRole hresult([out] bstr )
"CurrentAriaProperties hresult(bstr*);" & _ ;CurrentAriaProperties hresult([out] bstr )
"CurrentIsDataValidForForm hresult(long*);" & _ ;CurrentIsDataValidForForm hresult([out] int )
"CurrentControllerFor hresult(ptr*);" & _ ;CurrentControllerFor hresult([out] IUIAutomationElementArray **)
"CurrentDescribedBy hresult(ptr*);" & _ ;CurrentDescribedBy hresult([out] IUIAutomationElementArray **)
"CurrentFlowsTo hresult(ptr*);" & _ ;CurrentFlowsTo hresult([out] IUIAutomationElementArray **)
"CurrentProviderDescription hresult(bstr*);" & _ ;CurrentProviderDescription hresult([out] bstr )
"CachedProcessId hresult(int*);" & _ ;CachedProcessId hresult([out] int )
"CachedControlType hresult(int*);" & _ ;CachedControlType hresult([out] int )
"CachedLocalizedControlType hresult(bstr*);" & _ ;CachedLocalizedControlType hresult([out] bstr )
"CachedName hresult(bstr*);" & _ ;CachedName hresult([out] bstr )
"CachedAcceleratorKey hresult(bstr*);" & _ ;CachedAcceleratorKey hresult([out] bstr )
"CachedAccessKey hresult(bstr*);" & _ ;CachedAccessKey hresult([out] bstr )
"CachedHasKeyboardFocus hresult(long*);" & _ ;CachedHasKeyboardFocus hresult([out] int )
"CachedIsKeyboardFocusable hresult(long*);" & _ ;CachedIsKeyboardFocusable hresult([out] int )
"CachedIsEnabled hresult(long*);" & _ ;CachedIsEnabled hresult([out] int )
"CachedAutomationId hresult(bstr*);" & _ ;CachedAutomationId hresult([out] bstr )
"CachedClassName hresult(bstr*);" & _ ;CachedClassName hresult([out] bstr )
"CachedHelpText hresult(bstr*);" & _ ;CachedHelpText hresult([out] bstr )
"CachedCulture hresult(int*);" & _ ;CachedCulture hresult([out] int )
"CachedIsControlElement hresult(long*);" & _ ;CachedIsControlElement hresult([out] int )
"CachedIsContentElement hresult(long*);" & _ ;CachedIsContentElement hresult([out] int )
"CachedIsPassword hresult(long*);" & _ ;CachedIsPassword hresult([out] int )
"CachedNativeWindowHandle hresult(none*);" & _ ;CachedNativeWindowHandle hresult([out] void )
"CachedItemType hresult(bstr*);" & _ ;CachedItemType hresult([out] bstr )
"CachedIsOffscreen hresult(long*);" & _ ;CachedIsOffscreen hresult([out] int )
"CachedOrientation hresult(long*);" & _ ;CachedOrientation hresult([out] OrientationType *)
"CachedFrameworkId hresult(bstr*);" & _ ;CachedFrameworkId hresult([out] bstr )
"CachedIsRequiredForForm hresult(long*);" & _ ;CachedIsRequiredForForm hresult([out] int )
"CachedItemStatus hresult(bstr*);" & _ ;CachedItemStatus hresult([out] bstr )
"CachedBoundingRectangle hresult(none*);" & _ ;CachedBoundingRectangle hresult([out] tagRECT *)
"CachedLabeledBy hresult(ptr*);" & _ ;CachedLabeledBy hresult([out] IUIAutomationElement **)
"CachedAriaRole hresult(bstr*);" & _ ;CachedAriaRole hresult([out] bstr )
"CachedAriaProperties hresult(bstr*);" & _ ;CachedAriaProperties hresult([out] bstr )
"CachedIsDataValidForForm hresult(long*);" & _ ;CachedIsDataValidForForm hresult([out] int )
"CachedControllerFor hresult(ptr*);" & _ ;CachedControllerFor hresult([out] IUIAutomationElementArray **)
"CachedDescribedBy hresult(ptr*);" & _ ;CachedDescribedBy hresult([out] IUIAutomationElementArray **)
"CachedFlowsTo hresult(ptr*);" & _ ;CachedFlowsTo hresult([out] IUIAutomationElementArray **)
"CachedProviderDescription hresult(bstr*);" & _ ;CachedProviderDescription hresult([out] bstr )
"GetClickablePoint hresult(none*;long*);" ;GetClickablePoint hresult([out] tagPOINT *;[out] int )
;===============================================================================
;list
Global $ltagIUIAutomationElement = $ltagIUnknown & _
"SetFocus;" & _ 
"GetRuntimeId;" & _ 
"FindFirst;" & _ 
"FindAll;" & _ 
"FindFirstBuildCache;" & _ 
"FindAllBuildCache;" & _ 
"BuildUpdatedCache;" & _ 
"GetCurrentPropertyValue;" & _ 
"GetCurrentPropertyValueEx;" & _ 
"GetCachedPropertyValue;" & _ 
"GetCachedPropertyValueEx;" & _ 
"GetCurrentPatternAs;" & _ 
"GetCachedPatternAs;" & _ 
"GetCurrentPattern;" & _ 
"GetCachedPattern;" & _ 
"GetCachedParent;" & _ 
"GetCachedChildren;" & _ 
"CurrentProcessId;" & _ 
"CurrentControlType;" & _ 
"CurrentLocalizedControlType;" & _ 
"CurrentName;" & _ 
"CurrentAcceleratorKey;" & _ 
"CurrentAccessKey;" & _ 
"CurrentHasKeyboardFocus;" & _ 
"CurrentIsKeyboardFocusable;" & _ 
"CurrentIsEnabled;" & _ 
"CurrentAutomationId;" & _ 
"CurrentClassName;" & _ 
"CurrentHelpText;" & _ 
"CurrentCulture;" & _ 
"CurrentIsControlElement;" & _ 
"CurrentIsContentElement;" & _ 
"CurrentIsPassword;" & _ 
"CurrentNativeWindowHandle;" & _ 
"CurrentItemType;" & _ 
"CurrentIsOffscreen;" & _ 
"CurrentOrientation;" & _ 
"CurrentFrameworkId;" & _ 
"CurrentIsRequiredForForm;" & _ 
"CurrentItemStatus;" & _ 
"CurrentBoundingRectangle;" & _ 
"CurrentLabeledBy;" & _ 
"CurrentAriaRole;" & _ 
"CurrentAriaProperties;" & _ 
"CurrentIsDataValidForForm;" & _ 
"CurrentControllerFor;" & _ 
"CurrentDescribedBy;" & _ 
"CurrentFlowsTo;" & _ 
"CurrentProviderDescription;" & _ 
"CachedProcessId;" & _ 
"CachedControlType;" & _ 
"CachedLocalizedControlType;" & _ 
"CachedName;" & _ 
"CachedAcceleratorKey;" & _ 
"CachedAccessKey;" & _ 
"CachedHasKeyboardFocus;" & _ 
"CachedIsKeyboardFocusable;" & _ 
"CachedIsEnabled;" & _ 
"CachedAutomationId;" & _ 
"CachedClassName;" & _ 
"CachedHelpText;" & _ 
"CachedCulture;" & _ 
"CachedIsControlElement;" & _ 
"CachedIsContentElement;" & _ 
"CachedIsPassword;" & _ 
"CachedNativeWindowHandle;" & _ 
"CachedItemType;" & _ 
"CachedIsOffscreen;" & _ 
"CachedOrientation;" & _ 
"CachedFrameworkId;" & _ 
"CachedIsRequiredForForm;" & _ 
"CachedItemStatus;" & _ 
"CachedBoundingRectangle;" & _ 
"CachedLabeledBy;" & _ 
"CachedAriaRole;" & _ 
"CachedAriaProperties;" & _ 
"CachedIsDataValidForForm;" & _ 
"CachedControllerFor;" & _ 
"CachedDescribedBy;" & _ 
"CachedFlowsTo;" & _ 
"CachedProviderDescription;" & _ 
"GetClickablePoint;" 

;===============================================================================
Global Const $sIID_IUIAutomationCondition="{352FFBA8-0973-437C-A61F-F64CAFD81DF9}"
Global Const $cIID_IUIAutomationCondition=_AutoItObject_CLSIDFromString($sIID_IUIAutomationCondition)
Global $dtagIUIAutomationCondition = $dtagIUnknown 
;===============================================================================
;list
Global $ltagIUIAutomationCondition = $ltagIUnknown 

;===============================================================================
Global Const $sIID_IUIAutomationElementArray="{14314595-B4BC-4055-95F2-58F2E42C9855}"
Global Const $cIID_IUIAutomationElementArray=_AutoItObject_CLSIDFromString($sIID_IUIAutomationElementArray)
Global $dtagIUIAutomationElementArray = $dtagIUnknown & _
"Length hresult(int*);" & _ ;Length hresult([out] int )
"GetElement hresult(int;ptr*);" ;GetElement hresult([in] int ;[out] IUIAutomationElement **)
;===============================================================================
;list
Global $ltagIUIAutomationElementArray = $ltagIUnknown & _
"Length;" & _ 
"GetElement;" 

;===============================================================================
Global Const $sIID_IUIAutomationCacheRequest="{B32A92B5-BC25-4078-9C08-D7EE95C48E03}"
Global Const $cIID_IUIAutomationCacheRequest=_AutoItObject_CLSIDFromString($sIID_IUIAutomationCacheRequest)
Global $dtagIUIAutomationCacheRequest = $dtagIUnknown & _
"AddProperty hresult(int);" & _ ;AddProperty hresult([in] int )
"AddPattern hresult(int);" & _ ;AddPattern hresult([in] int )
"Clone hresult(ptr*);" & _ ;Clone hresult([out] IUIAutomationCacheRequest **)
"TreeScope hresult(long*);" & _ ;TreeScope hresult([out] TreeScope *)
"TreeScope hresult(long);" & _ ;TreeScope hresult([in] TreeScope )
"TreeFilter hresult(ptr*);" & _ ;TreeFilter hresult([out] IUIAutomationCondition **)
"TreeFilter hresult(ptr);" & _ ;TreeFilter hresult([in] IUIAutomationCondition *)
"AutomationElementMode hresult(long*);" & _ ;AutomationElementMode hresult([out] AutomationElementMode *)
"AutomationElementMode hresult(long);" ;AutomationElementMode hresult([in] AutomationElementMode )
;===============================================================================
;list
Global $ltagIUIAutomationCacheRequest = $ltagIUnknown & _
"AddProperty;" & _ 
"AddPattern;" & _ 
"Clone;" & _ 
"TreeScope;" & _ 
"TreeScope;" & _ 
"TreeFilter;" & _ 
"TreeFilter;" & _ 
"AutomationElementMode;" & _ 
"AutomationElementMode;" 

;===============================================================================
Global Const $sIID_IUIAutomationBoolCondition="{1B4E1F2E-75EB-4D0B-8952-5A69988E2307}"
Global Const $cIID_IUIAutomationBoolCondition=_AutoItObject_CLSIDFromString($sIID_IUIAutomationBoolCondition)
Global $dtagIUIAutomationBoolCondition = $dtagIUnknown & _
"BooleanValue hresult(long*);" ;BooleanValue hresult([out] int )
;===============================================================================
;list
Global $ltagIUIAutomationBoolCondition = $ltagIUnknown & _
"BooleanValue;" 

;===============================================================================
Global Const $sIID_IUIAutomationPropertyCondition="{99EBF2CB-5578-4267-9AD4-AFD6EA77E94B}"
Global Const $cIID_IUIAutomationPropertyCondition=_AutoItObject_CLSIDFromString($sIID_IUIAutomationPropertyCondition)
Global $dtagIUIAutomationPropertyCondition = $dtagIUnknown & _
"propertyId hresult(int*);" & _ ;propertyId hresult([out] int )
"PropertyValue hresult(variant*);" & _ ;PropertyValue hresult([out] variant )
"PropertyConditionFlags hresult(long*);" ;PropertyConditionFlags hresult([out] PropertyConditionFlags *)
;===============================================================================
;list
Global $ltagIUIAutomationPropertyCondition = $ltagIUnknown & _
"propertyId;" & _ 
"PropertyValue;" & _ 
"PropertyConditionFlags;" 

;===============================================================================
Global Const $sIID_IUIAutomationAndCondition="{A7D0AF36-B912-45FE-9855-091DDC174AEC}"
Global Const $cIID_IUIAutomationAndCondition=_AutoItObject_CLSIDFromString($sIID_IUIAutomationAndCondition)
Global $dtagIUIAutomationAndCondition = $dtagIUnknown & _
"ChildCount hresult(int*);" & _ ;ChildCount hresult([out] int )
"GetChildrenAsNativeArray hresult(ptr*;int*);" & _ ;GetChildrenAsNativeArray hresult([out] IUIAutomationCondition ***;[out] int )
"GetChildren hresult(ptr*);" ;GetChildren hresult([out] IUIAutomationCondition *)
;===============================================================================
;list
Global $ltagIUIAutomationAndCondition = $ltagIUnknown & _
"ChildCount;" & _ 
"GetChildrenAsNativeArray;" & _ 
"GetChildren;" 

;===============================================================================
Global Const $sIID_IUIAutomationOrCondition="{8753F032-3DB1-47B5-A1FC-6E34A266C712}"
Global Const $cIID_IUIAutomationOrCondition=_AutoItObject_CLSIDFromString($sIID_IUIAutomationOrCondition)
Global $dtagIUIAutomationOrCondition = $dtagIUnknown & _
"ChildCount hresult(int*);" & _ ;ChildCount hresult([out] int )
"GetChildrenAsNativeArray hresult(ptr*;int*);" & _ ;GetChildrenAsNativeArray hresult([out] IUIAutomationCondition ***;[out] int )
"GetChildren hresult(ptr*);" ;GetChildren hresult([out] IUIAutomationCondition *)
;===============================================================================
;list
Global $ltagIUIAutomationOrCondition = $ltagIUnknown & _
"ChildCount;" & _ 
"GetChildrenAsNativeArray;" & _ 
"GetChildren;" 

;===============================================================================
Global Const $sIID_IUIAutomationNotCondition="{F528B657-847B-498C-8896-D52B565407A1}"
Global Const $cIID_IUIAutomationNotCondition=_AutoItObject_CLSIDFromString($sIID_IUIAutomationNotCondition)
Global $dtagIUIAutomationNotCondition = $dtagIUnknown & _
"GetChild hresult(ptr*);" ;GetChild hresult([out] IUIAutomationCondition **)
;===============================================================================
;list
Global $ltagIUIAutomationNotCondition = $ltagIUnknown & _
"GetChild;" 

;===============================================================================
Global Const $sIID_IUIAutomationTreeWalker="{4042C624-389C-4AFC-A630-9DF854A541FC}"
Global Const $cIID_IUIAutomationTreeWalker=_AutoItObject_CLSIDFromString($sIID_IUIAutomationTreeWalker)
Global $dtagIUIAutomationTreeWalker = $dtagIUnknown & _
"GetParentElement hresult(ptr;ptr*);" & _ ;GetParentElement hresult([in] IUIAutomationElement *;[out] IUIAutomationElement **)
"GetFirstChildElement hresult(ptr;ptr*);" & _ ;GetFirstChildElement hresult([in] IUIAutomationElement *;[out] IUIAutomationElement **)
"GetLastChildElement hresult(ptr;ptr*);" & _ ;GetLastChildElement hresult([in] IUIAutomationElement *;[out] IUIAutomationElement **)
"GetNextSiblingElement hresult(ptr;ptr*);" & _ ;GetNextSiblingElement hresult([in] IUIAutomationElement *;[out] IUIAutomationElement **)
"GetPreviousSiblingElement hresult(ptr;ptr*);" & _ ;GetPreviousSiblingElement hresult([in] IUIAutomationElement *;[out] IUIAutomationElement **)
"NormalizeElement hresult(ptr;ptr*);" & _ ;NormalizeElement hresult([in] IUIAutomationElement *;[out] IUIAutomationElement **)
"GetParentElementBuildCache hresult(ptr;ptr;ptr*);" & _ ;GetParentElementBuildCache hresult([in] IUIAutomationElement *;[in] IUIAutomationCacheRequest *;[out] IUIAutomationElement **)
"GetFirstChildElementBuildCache hresult(ptr;ptr;ptr*);" & _ ;GetFirstChildElementBuildCache hresult([in] IUIAutomationElement *;[in] IUIAutomationCacheRequest *;[out] IUIAutomationElement **)
"GetLastChildElementBuildCache hresult(ptr;ptr;ptr*);" & _ ;GetLastChildElementBuildCache hresult([in] IUIAutomationElement *;[in] IUIAutomationCacheRequest *;[out] IUIAutomationElement **)
"GetNextSiblingElementBuildCache hresult(ptr;ptr;ptr*);" & _ ;GetNextSiblingElementBuildCache hresult([in] IUIAutomationElement *;[in] IUIAutomationCacheRequest *;[out] IUIAutomationElement **)
"GetPreviousSiblingElementBuildCache hresult(ptr;ptr;ptr*);" & _ ;GetPreviousSiblingElementBuildCache hresult([in] IUIAutomationElement *;[in] IUIAutomationCacheRequest *;[out] IUIAutomationElement **)
"NormalizeElementBuildCache hresult(ptr;ptr;ptr*);" & _ ;NormalizeElementBuildCache hresult([in] IUIAutomationElement *;[in] IUIAutomationCacheRequest *;[out] IUIAutomationElement **)
"condition hresult(ptr*);" ;condition hresult([out] IUIAutomationCondition **)
;===============================================================================
;list
Global $ltagIUIAutomationTreeWalker = $ltagIUnknown & _
"GetParentElement;" & _ 
"GetFirstChildElement;" & _ 
"GetLastChildElement;" & _ 
"GetNextSiblingElement;" & _ 
"GetPreviousSiblingElement;" & _ 
"NormalizeElement;" & _ 
"GetParentElementBuildCache;" & _ 
"GetFirstChildElementBuildCache;" & _ 
"GetLastChildElementBuildCache;" & _ 
"GetNextSiblingElementBuildCache;" & _ 
"GetPreviousSiblingElementBuildCache;" & _ 
"NormalizeElementBuildCache;" & _ 
"condition;" 

;===============================================================================
Global Const $sIID_IUIAutomationEventHandler="{146C3C17-F12E-4E22-8C27-F894B9B79C69}"
Global Const $cIID_IUIAutomationEventHandler=_AutoItObject_CLSIDFromString($sIID_IUIAutomationEventHandler)
Global $dtagIUIAutomationEventHandler = $dtagIUnknown & _
"HandleAutomationEvent hresult(ptr;int);" ;HandleAutomationEvent hresult([in] IUIAutomationElement *;[in] int )
;===============================================================================
;list
Global $ltagIUIAutomationEventHandler = $ltagIUnknown & _
"HandleAutomationEvent;" 

;===============================================================================
Global Const $sIID_IUIAutomationPropertyChangedEventHandler="{40CD37D4-C756-4B0C-8C6F-BDDFEEB13B50}"
Global Const $cIID_IUIAutomationPropertyChangedEventHandler=_AutoItObject_CLSIDFromString($sIID_IUIAutomationPropertyChangedEventHandler)
Global $dtagIUIAutomationPropertyChangedEventHandler = $dtagIUnknown & _
"HandlePropertyChangedEvent hresult(ptr;int;variant);" ;HandlePropertyChangedEvent hresult([in] IUIAutomationElement *;[in] int ;[in] variant )
;===============================================================================
;list
Global $ltagIUIAutomationPropertyChangedEventHandler = $ltagIUnknown & _
"HandlePropertyChangedEvent;" 

;===============================================================================
Global Const $sIID_IUIAutomationStructureChangedEventHandler="{E81D1B4E-11C5-42F8-9754-E7036C79F054}"
Global Const $cIID_IUIAutomationStructureChangedEventHandler=_AutoItObject_CLSIDFromString($sIID_IUIAutomationStructureChangedEventHandler)
Global $dtagIUIAutomationStructureChangedEventHandler = $dtagIUnknown & _
"HandleStructureChangedEvent hresult(ptr;long;ptr);" ;HandleStructureChangedEvent hresult([in] IUIAutomationElement *;[in] StructureChangeType ;[in] ne )
;===============================================================================
;list
Global $ltagIUIAutomationStructureChangedEventHandler = $ltagIUnknown & _
"HandleStructureChangedEvent;" 

;===============================================================================
Global Const $sIID_IUIAutomationFocusChangedEventHandler="{C270F6B5-5C69-4290-9745-7A7F97169468}"
Global Const $cIID_IUIAutomationFocusChangedEventHandler=_AutoItObject_CLSIDFromString($sIID_IUIAutomationFocusChangedEventHandler)
Global $dtagIUIAutomationFocusChangedEventHandler = $dtagIUnknown & _
"HandleFocusChangedEvent hresult(ptr);" ;HandleFocusChangedEvent hresult([in] IUIAutomationElement *)
;===============================================================================
;list
Global $ltagIUIAutomationFocusChangedEventHandler = $ltagIUnknown & _
"HandleFocusChangedEvent;" 

;===============================================================================
Global Const $sIID_IUIAutomationInvokePattern="{FB377FBE-8EA6-46D5-9C73-6499642D3059}"
Global Const $cIID_IUIAutomationInvokePattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationInvokePattern)
Global $dtagIUIAutomationInvokePattern = $dtagIUnknown & _
"Invoke hresult();" ;Invoke hresult()
;===============================================================================
;list
Global $ltagIUIAutomationInvokePattern = $ltagIUnknown & _
"Invoke;" 

;===============================================================================
Global Const $sIID_IUIAutomationDockPattern="{FDE5EF97-1464-48F6-90BF-43D0948E86EC}"
Global Const $cIID_IUIAutomationDockPattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationDockPattern)
Global $dtagIUIAutomationDockPattern = $dtagIUnknown & _
"SetDockPosition hresult(long);" & _ ;SetDockPosition hresult([in] DockPosition )
"CurrentDockPosition hresult(long*);" & _ ;CurrentDockPosition hresult([out] DockPosition *)
"CachedDockPosition hresult(long*);" ;CachedDockPosition hresult([out] DockPosition *)
;===============================================================================
;list
Global $ltagIUIAutomationDockPattern = $ltagIUnknown & _
"SetDockPosition;" & _ 
"CurrentDockPosition;" & _ 
"CachedDockPosition;" 

;===============================================================================
Global Const $sIID_IUIAutomationExpandCollapsePattern="{619BE086-1F4E-4EE4-BAFA-210128738730}"
Global Const $cIID_IUIAutomationExpandCollapsePattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationExpandCollapsePattern)
Global $dtagIUIAutomationExpandCollapsePattern = $dtagIUnknown & _
"Expand hresult();" & _ ;Expand hresult()
"Collapse hresult();" & _ ;Collapse hresult()
"CurrentExpandCollapseState hresult(long*);" & _ ;CurrentExpandCollapseState hresult([out] ExpandCollapseState *)
"CachedExpandCollapseState hresult(long*);" ;CachedExpandCollapseState hresult([out] ExpandCollapseState *)
;===============================================================================
;list
Global $ltagIUIAutomationExpandCollapsePattern = $ltagIUnknown & _
"Expand;" & _ 
"Collapse;" & _ 
"CurrentExpandCollapseState;" & _ 
"CachedExpandCollapseState;" 

;===============================================================================
Global Const $sIID_IUIAutomationGridPattern="{414C3CDC-856B-4F5B-8538-3131C6302550}"
Global Const $cIID_IUIAutomationGridPattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationGridPattern)
Global $dtagIUIAutomationGridPattern = $dtagIUnknown & _
"GetItem hresult(int;int;ptr*);" & _ ;GetItem hresult([in] int ;[in] int ;[out] IUIAutomationElement **)
"CurrentRowCount hresult(int*);" & _ ;CurrentRowCount hresult([out] int )
"CurrentColumnCount hresult(int*);" & _ ;CurrentColumnCount hresult([out] int )
"CachedRowCount hresult(int*);" & _ ;CachedRowCount hresult([out] int )
"CachedColumnCount hresult(int*);" ;CachedColumnCount hresult([out] int )
;===============================================================================
;list
Global $ltagIUIAutomationGridPattern = $ltagIUnknown & _
"GetItem;" & _ 
"CurrentRowCount;" & _ 
"CurrentColumnCount;" & _ 
"CachedRowCount;" & _ 
"CachedColumnCount;" 

;===============================================================================
Global Const $sIID_IUIAutomationGridItemPattern="{78F8EF57-66C3-4E09-BD7C-E79B2004894D}"
Global Const $cIID_IUIAutomationGridItemPattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationGridItemPattern)
Global $dtagIUIAutomationGridItemPattern = $dtagIUnknown & _
"CurrentContainingGrid hresult(ptr*);" & _ ;CurrentContainingGrid hresult([out] IUIAutomationElement **)
"CurrentRow hresult(int*);" & _ ;CurrentRow hresult([out] int )
"CurrentColumn hresult(int*);" & _ ;CurrentColumn hresult([out] int )
"CurrentRowSpan hresult(int*);" & _ ;CurrentRowSpan hresult([out] int )
"CurrentColumnSpan hresult(int*);" & _ ;CurrentColumnSpan hresult([out] int )
"CachedContainingGrid hresult(ptr*);" & _ ;CachedContainingGrid hresult([out] IUIAutomationElement **)
"CachedRow hresult(int*);" & _ ;CachedRow hresult([out] int )
"CachedColumn hresult(int*);" & _ ;CachedColumn hresult([out] int )
"CachedRowSpan hresult(int*);" & _ ;CachedRowSpan hresult([out] int )
"CachedColumnSpan hresult(int*);" ;CachedColumnSpan hresult([out] int )
;===============================================================================
;list
Global $ltagIUIAutomationGridItemPattern = $ltagIUnknown & _
"CurrentContainingGrid;" & _ 
"CurrentRow;" & _ 
"CurrentColumn;" & _ 
"CurrentRowSpan;" & _ 
"CurrentColumnSpan;" & _ 
"CachedContainingGrid;" & _ 
"CachedRow;" & _ 
"CachedColumn;" & _ 
"CachedRowSpan;" & _ 
"CachedColumnSpan;" 

;===============================================================================
Global Const $sIID_IUIAutomationMultipleViewPattern="{8D253C91-1DC5-4BB5-B18F-ADE16FA495E8}"
Global Const $cIID_IUIAutomationMultipleViewPattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationMultipleViewPattern)
Global $dtagIUIAutomationMultipleViewPattern = $dtagIUnknown & _
"GetViewName hresult(int;bstr*);" & _ ;GetViewName hresult([in] int ;[out] bstr )
"SetCurrentView hresult(int);" & _ ;SetCurrentView hresult([in] int )
"CurrentCurrentView hresult(int*);" & _ ;CurrentCurrentView hresult([out] int )
"GetCurrentSupportedViews hresult(ptr*);" & _ ;GetCurrentSupportedViews hresult([out] ne )
"CachedCurrentView hresult(int*);" & _ ;CachedCurrentView hresult([out] int )
"GetCachedSupportedViews hresult(ptr*);" ;GetCachedSupportedViews hresult([out] ne )
;===============================================================================
;list
Global $ltagIUIAutomationMultipleViewPattern = $ltagIUnknown & _
"GetViewName;" & _ 
"SetCurrentView;" & _ 
"CurrentCurrentView;" & _ 
"GetCurrentSupportedViews;" & _ 
"CachedCurrentView;" & _ 
"GetCachedSupportedViews;" 

;===============================================================================
Global Const $sIID_IUIAutomationRangeValuePattern="{59213F4F-7346-49E5-B120-80555987A148}"
Global Const $cIID_IUIAutomationRangeValuePattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationRangeValuePattern)
Global $dtagIUIAutomationRangeValuePattern = $dtagIUnknown & _
"SetValue hresult(ushort);" & _ ;SetValue hresult([in] double )
"CurrentValue hresult(ushort*);" & _ ;CurrentValue hresult([out] double )
"CurrentIsReadOnly hresult(long*);" & _ ;CurrentIsReadOnly hresult([out] int )
"CurrentMaximum hresult(ushort*);" & _ ;CurrentMaximum hresult([out] double )
"CurrentMinimum hresult(ushort*);" & _ ;CurrentMinimum hresult([out] double )
"CurrentLargeChange hresult(ushort*);" & _ ;CurrentLargeChange hresult([out] double )
"CurrentSmallChange hresult(ushort*);" & _ ;CurrentSmallChange hresult([out] double )
"CachedValue hresult(ushort*);" & _ ;CachedValue hresult([out] double )
"CachedIsReadOnly hresult(long*);" & _ ;CachedIsReadOnly hresult([out] int )
"CachedMaximum hresult(ushort*);" & _ ;CachedMaximum hresult([out] double )
"CachedMinimum hresult(ushort*);" & _ ;CachedMinimum hresult([out] double )
"CachedLargeChange hresult(ushort*);" & _ ;CachedLargeChange hresult([out] double )
"CachedSmallChange hresult(ushort*);" ;CachedSmallChange hresult([out] double )
;===============================================================================
;list
Global $ltagIUIAutomationRangeValuePattern = $ltagIUnknown & _
"SetValue;" & _ 
"CurrentValue;" & _ 
"CurrentIsReadOnly;" & _ 
"CurrentMaximum;" & _ 
"CurrentMinimum;" & _ 
"CurrentLargeChange;" & _ 
"CurrentSmallChange;" & _ 
"CachedValue;" & _ 
"CachedIsReadOnly;" & _ 
"CachedMaximum;" & _ 
"CachedMinimum;" & _ 
"CachedLargeChange;" & _ 
"CachedSmallChange;" 

;===============================================================================
Global Const $sIID_IUIAutomationScrollPattern="{88F4D42A-E881-459D-A77C-73BBBB7E02DC}"
Global Const $cIID_IUIAutomationScrollPattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationScrollPattern)
Global $dtagIUIAutomationScrollPattern = $dtagIUnknown & _
"Scroll hresult(long;long);" & _ ;Scroll hresult([in] ScrollAmount ;[in] ScrollAmount )
"SetScrollPercent hresult(ushort;ushort);" & _ ;SetScrollPercent hresult([in] double ;[in] double )
"CurrentHorizontalScrollPercent hresult(ushort*);" & _ ;CurrentHorizontalScrollPercent hresult([out] double )
"CurrentVerticalScrollPercent hresult(ushort*);" & _ ;CurrentVerticalScrollPercent hresult([out] double )
"CurrentHorizontalViewSize hresult(ushort*);" & _ ;CurrentHorizontalViewSize hresult([out] double )
"CurrentVerticalViewSize hresult(ushort*);" & _ ;CurrentVerticalViewSize hresult([out] double )
"CurrentHorizontallyScrollable hresult(long*);" & _ ;CurrentHorizontallyScrollable hresult([out] int )
"CurrentVerticallyScrollable hresult(long*);" & _ ;CurrentVerticallyScrollable hresult([out] int )
"CachedHorizontalScrollPercent hresult(ushort*);" & _ ;CachedHorizontalScrollPercent hresult([out] double )
"CachedVerticalScrollPercent hresult(ushort*);" & _ ;CachedVerticalScrollPercent hresult([out] double )
"CachedHorizontalViewSize hresult(ushort*);" & _ ;CachedHorizontalViewSize hresult([out] double )
"CachedVerticalViewSize hresult(ushort*);" & _ ;CachedVerticalViewSize hresult([out] double )
"CachedHorizontallyScrollable hresult(long*);" & _ ;CachedHorizontallyScrollable hresult([out] int )
"CachedVerticallyScrollable hresult(long*);" ;CachedVerticallyScrollable hresult([out] int )
;===============================================================================
;list
Global $ltagIUIAutomationScrollPattern = $ltagIUnknown & _
"Scroll;" & _ 
"SetScrollPercent;" & _ 
"CurrentHorizontalScrollPercent;" & _ 
"CurrentVerticalScrollPercent;" & _ 
"CurrentHorizontalViewSize;" & _ 
"CurrentVerticalViewSize;" & _ 
"CurrentHorizontallyScrollable;" & _ 
"CurrentVerticallyScrollable;" & _ 
"CachedHorizontalScrollPercent;" & _ 
"CachedVerticalScrollPercent;" & _ 
"CachedHorizontalViewSize;" & _ 
"CachedVerticalViewSize;" & _ 
"CachedHorizontallyScrollable;" & _ 
"CachedVerticallyScrollable;" 

;===============================================================================
Global Const $sIID_IUIAutomationScrollItemPattern="{B488300F-D015-4F19-9C29-BB595E3645EF}"
Global Const $cIID_IUIAutomationScrollItemPattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationScrollItemPattern)
Global $dtagIUIAutomationScrollItemPattern = $dtagIUnknown & _
"ScrollIntoView hresult();" ;ScrollIntoView hresult()
;===============================================================================
;list
Global $ltagIUIAutomationScrollItemPattern = $ltagIUnknown & _
"ScrollIntoView;" 

;===============================================================================
Global Const $sIID_IUIAutomationSelectionPattern="{5ED5202E-B2AC-47A6-B638-4B0BF140D78E}"
Global Const $cIID_IUIAutomationSelectionPattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationSelectionPattern)
Global $dtagIUIAutomationSelectionPattern = $dtagIUnknown & _
"GetCurrentSelection hresult(ptr*);" & _ ;GetCurrentSelection hresult([out] IUIAutomationElementArray **)
"CurrentCanSelectMultiple hresult(long*);" & _ ;CurrentCanSelectMultiple hresult([out] int )
"CurrentIsSelectionRequired hresult(long*);" & _ ;CurrentIsSelectionRequired hresult([out] int )
"GetCachedSelection hresult(ptr*);" & _ ;GetCachedSelection hresult([out] IUIAutomationElementArray **)
"CachedCanSelectMultiple hresult(long*);" & _ ;CachedCanSelectMultiple hresult([out] int )
"CachedIsSelectionRequired hresult(long*);" ;CachedIsSelectionRequired hresult([out] int )
;===============================================================================
;list
Global $ltagIUIAutomationSelectionPattern = $ltagIUnknown & _
"GetCurrentSelection;" & _ 
"CurrentCanSelectMultiple;" & _ 
"CurrentIsSelectionRequired;" & _ 
"GetCachedSelection;" & _ 
"CachedCanSelectMultiple;" & _ 
"CachedIsSelectionRequired;" 

;===============================================================================
Global Const $sIID_IUIAutomationSelectionItemPattern="{A8EFA66A-0FDA-421A-9194-38021F3578EA}"
Global Const $cIID_IUIAutomationSelectionItemPattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationSelectionItemPattern)
Global $dtagIUIAutomationSelectionItemPattern = $dtagIUnknown & _
"Select hresult();" & _ ;Select hresult()
"AddToSelection hresult();" & _ ;AddToSelection hresult()
"RemoveFromSelection hresult();" & _ ;RemoveFromSelection hresult()
"CurrentIsSelected hresult(long*);" & _ ;CurrentIsSelected hresult([out] int )
"CurrentSelectionContainer hresult(ptr*);" & _ ;CurrentSelectionContainer hresult([out] IUIAutomationElement **)
"CachedIsSelected hresult(long*);" & _ ;CachedIsSelected hresult([out] int )
"CachedSelectionContainer hresult(ptr*);" ;CachedSelectionContainer hresult([out] IUIAutomationElement **)
;===============================================================================
;list
Global $ltagIUIAutomationSelectionItemPattern = $ltagIUnknown & _
"Select;" & _ 
"AddToSelection;" & _ 
"RemoveFromSelection;" & _ 
"CurrentIsSelected;" & _ 
"CurrentSelectionContainer;" & _ 
"CachedIsSelected;" & _ 
"CachedSelectionContainer;" 

;===============================================================================
Global Const $sIID_IUIAutomationSynchronizedInputPattern="{2233BE0B-AFB7-448B-9FDA-3B378AA5EAE1}"
Global Const $cIID_IUIAutomationSynchronizedInputPattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationSynchronizedInputPattern)
Global $dtagIUIAutomationSynchronizedInputPattern = $dtagIUnknown & _
"StartListening hresult(long);" & _ ;StartListening hresult([in] SynchronizedInputType )
"Cancel hresult();" ;Cancel hresult()
;===============================================================================
;list
Global $ltagIUIAutomationSynchronizedInputPattern = $ltagIUnknown & _
"StartListening;" & _ 
"Cancel;" 

;===============================================================================
Global Const $sIID_IUIAutomationTablePattern="{620E691C-EA96-4710-A850-754B24CE2417}"
Global Const $cIID_IUIAutomationTablePattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationTablePattern)
Global $dtagIUIAutomationTablePattern = $dtagIUnknown & _
"GetCurrentRowHeaders hresult(ptr*);" & _ ;GetCurrentRowHeaders hresult([out] IUIAutomationElementArray **)
"GetCurrentColumnHeaders hresult(ptr*);" & _ ;GetCurrentColumnHeaders hresult([out] IUIAutomationElementArray **)
"CurrentRowOrColumnMajor hresult(long*);" & _ ;CurrentRowOrColumnMajor hresult([out] RowOrColumnMajor *)
"GetCachedRowHeaders hresult(ptr*);" & _ ;GetCachedRowHeaders hresult([out] IUIAutomationElementArray **)
"GetCachedColumnHeaders hresult(ptr*);" & _ ;GetCachedColumnHeaders hresult([out] IUIAutomationElementArray **)
"CachedRowOrColumnMajor hresult(long*);" ;CachedRowOrColumnMajor hresult([out] RowOrColumnMajor *)
;===============================================================================
;list
Global $ltagIUIAutomationTablePattern = $ltagIUnknown & _
"GetCurrentRowHeaders;" & _ 
"GetCurrentColumnHeaders;" & _ 
"CurrentRowOrColumnMajor;" & _ 
"GetCachedRowHeaders;" & _ 
"GetCachedColumnHeaders;" & _ 
"CachedRowOrColumnMajor;" 

;===============================================================================
Global Const $sIID_IUIAutomationTableItemPattern="{0B964EB3-EF2E-4464-9C79-61D61737A27E}"
Global Const $cIID_IUIAutomationTableItemPattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationTableItemPattern)
Global $dtagIUIAutomationTableItemPattern = $dtagIUnknown & _
"GetCurrentRowHeaderItems hresult(ptr*);" & _ ;GetCurrentRowHeaderItems hresult([out] IUIAutomationElementArray **)
"GetCurrentColumnHeaderItems hresult(ptr*);" & _ ;GetCurrentColumnHeaderItems hresult([out] IUIAutomationElementArray **)
"GetCachedRowHeaderItems hresult(ptr*);" & _ ;GetCachedRowHeaderItems hresult([out] IUIAutomationElementArray **)
"GetCachedColumnHeaderItems hresult(ptr*);" ;GetCachedColumnHeaderItems hresult([out] IUIAutomationElementArray **)
;===============================================================================
;list
Global $ltagIUIAutomationTableItemPattern = $ltagIUnknown & _
"GetCurrentRowHeaderItems;" & _ 
"GetCurrentColumnHeaderItems;" & _ 
"GetCachedRowHeaderItems;" & _ 
"GetCachedColumnHeaderItems;" 

;===============================================================================
Global Const $sIID_IUIAutomationTogglePattern="{94CF8058-9B8D-4AB9-8BFD-4CD0A33C8C70}"
Global Const $cIID_IUIAutomationTogglePattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationTogglePattern)
Global $dtagIUIAutomationTogglePattern = $dtagIUnknown & _
"Toggle hresult();" & _ ;Toggle hresult()
"CurrentToggleState hresult(long*);" & _ ;CurrentToggleState hresult([out] ToggleState *)
"CachedToggleState hresult(long*);" ;CachedToggleState hresult([out] ToggleState *)
;===============================================================================
;list
Global $ltagIUIAutomationTogglePattern = $ltagIUnknown & _
"Toggle;" & _ 
"CurrentToggleState;" & _ 
"CachedToggleState;" 

;===============================================================================
Global Const $sIID_IUIAutomationTransformPattern="{A9B55844-A55D-4EF0-926D-569C16FF89BB}"
Global Const $cIID_IUIAutomationTransformPattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationTransformPattern)
Global $dtagIUIAutomationTransformPattern = $dtagIUnknown & _
"Move hresult(ushort;ushort);" & _ ;Move hresult([in] double ;[in] double )
"Resize hresult(ushort;ushort);" & _ ;Resize hresult([in] double ;[in] double )
"Rotate hresult(ushort);" & _ ;Rotate hresult([in] double )
"CurrentCanMove hresult(long*);" & _ ;CurrentCanMove hresult([out] int )
"CurrentCanResize hresult(long*);" & _ ;CurrentCanResize hresult([out] int )
"CurrentCanRotate hresult(long*);" & _ ;CurrentCanRotate hresult([out] int )
"CachedCanMove hresult(long*);" & _ ;CachedCanMove hresult([out] int )
"CachedCanResize hresult(long*);" & _ ;CachedCanResize hresult([out] int )
"CachedCanRotate hresult(long*);" ;CachedCanRotate hresult([out] int )
;===============================================================================
;list
Global $ltagIUIAutomationTransformPattern = $ltagIUnknown & _
"Move;" & _ 
"Resize;" & _ 
"Rotate;" & _ 
"CurrentCanMove;" & _ 
"CurrentCanResize;" & _ 
"CurrentCanRotate;" & _ 
"CachedCanMove;" & _ 
"CachedCanResize;" & _ 
"CachedCanRotate;" 

;===============================================================================
Global Const $sIID_IUIAutomationValuePattern="{A94CD8B1-0844-4CD6-9D2D-640537AB39E9}"
Global Const $cIID_IUIAutomationValuePattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationValuePattern)
Global $dtagIUIAutomationValuePattern = $dtagIUnknown & _
"SetValue hresult(bstr);" & _ ;SetValue hresult([in] bstr )
"CurrentValue hresult(bstr*);" & _ ;CurrentValue hresult([out] bstr )
"CurrentIsReadOnly hresult(long*);" & _ ;CurrentIsReadOnly hresult([out] int )
"CachedValue hresult(bstr*);" & _ ;CachedValue hresult([out] bstr )
"CachedIsReadOnly hresult(long*);" ;CachedIsReadOnly hresult([out] int )
;===============================================================================
;list
Global $ltagIUIAutomationValuePattern = $ltagIUnknown & _
"SetValue;" & _ 
"CurrentValue;" & _ 
"CurrentIsReadOnly;" & _ 
"CachedValue;" & _ 
"CachedIsReadOnly;" 

;===============================================================================
Global Const $sIID_IUIAutomationWindowPattern="{0FAEF453-9208-43EF-BBB2-3B485177864F}"
Global Const $cIID_IUIAutomationWindowPattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationWindowPattern)
Global $dtagIUIAutomationWindowPattern = $dtagIUnknown & _
"Close hresult();" & _ ;Close hresult()
"WaitForInputIdle hresult(int;long*);" & _ ;WaitForInputIdle hresult([in] int ;[out] int )
"SetWindowVisualState hresult(long);" & _ ;SetWindowVisualState hresult([in] WindowVisualState )
"CurrentCanMaximize hresult(long*);" & _ ;CurrentCanMaximize hresult([out] int )
"CurrentCanMinimize hresult(long*);" & _ ;CurrentCanMinimize hresult([out] int )
"CurrentIsModal hresult(long*);" & _ ;CurrentIsModal hresult([out] int )
"CurrentIsTopmost hresult(long*);" & _ ;CurrentIsTopmost hresult([out] int )
"CurrentWindowVisualState hresult(long*);" & _ ;CurrentWindowVisualState hresult([out] WindowVisualState *)
"CurrentWindowInteractionState hresult(long*);" & _ ;CurrentWindowInteractionState hresult([out] WindowInteractionState *)
"CachedCanMaximize hresult(long*);" & _ ;CachedCanMaximize hresult([out] int )
"CachedCanMinimize hresult(long*);" & _ ;CachedCanMinimize hresult([out] int )
"CachedIsModal hresult(long*);" & _ ;CachedIsModal hresult([out] int )
"CachedIsTopmost hresult(long*);" & _ ;CachedIsTopmost hresult([out] int )
"CachedWindowVisualState hresult(long*);" & _ ;CachedWindowVisualState hresult([out] WindowVisualState *)
"CachedWindowInteractionState hresult(long*);" ;CachedWindowInteractionState hresult([out] WindowInteractionState *)
;===============================================================================
;list
Global $ltagIUIAutomationWindowPattern = $ltagIUnknown & _
"Close;" & _ 
"WaitForInputIdle;" & _ 
"SetWindowVisualState;" & _ 
"CurrentCanMaximize;" & _ 
"CurrentCanMinimize;" & _ 
"CurrentIsModal;" & _ 
"CurrentIsTopmost;" & _ 
"CurrentWindowVisualState;" & _ 
"CurrentWindowInteractionState;" & _ 
"CachedCanMaximize;" & _ 
"CachedCanMinimize;" & _ 
"CachedIsModal;" & _ 
"CachedIsTopmost;" & _ 
"CachedWindowVisualState;" & _ 
"CachedWindowInteractionState;" 

;===============================================================================
Global Const $sIID_IUIAutomationTextRange="{A543CC6A-F4AE-494B-8239-C814481187A8}"
Global Const $cIID_IUIAutomationTextRange=_AutoItObject_CLSIDFromString($sIID_IUIAutomationTextRange)
Global $dtagIUIAutomationTextRange = $dtagIUnknown & _
"Clone hresult(ptr*);" & _ ;Clone hresult([out] IUIAutomationTextRange **)
"Compare hresult(ptr;long*);" & _ ;Compare hresult([in] IUIAutomationTextRange *;[out] int )
"CompareEndpoints hresult(long;ptr;long;int*);" & _ ;CompareEndpoints hresult([in] TextPatternRangeEndpoint ;[in] IUIAutomationTextRange *;[in] TextPatternRangeEndpoint ;[out] int )
"ExpandToEnclosingUnit hresult(long);" & _ ;ExpandToEnclosingUnit hresult([in] TextUnit )
"FindAttribute hresult(int;variant;long;ptr*);" & _ ;FindAttribute hresult([in] int ;[in] variant ;[in] int ;[out] IUIAutomationTextRange **)
"FindText hresult(bstr;long;long;ptr*);" & _ ;FindText hresult([in] bstr ;[in] int ;[in] int ;[out] IUIAutomationTextRange **)
"GetAttributeValue hresult(int;variant*);" & _ ;GetAttributeValue hresult([in] int ;[out] variant )
"GetBoundingRectangles hresult(ptr*);" & _ ;GetBoundingRectangles hresult([out] ne )
"GetEnclosingElement hresult(ptr*);" & _ ;GetEnclosingElement hresult([out] IUIAutomationElement **)
"GetText hresult(int;bstr*);" & _ ;GetText hresult([in] int ;[out] bstr )
"Move hresult(long;int;int*);" & _ ;Move hresult([in] TextUnit ;[in] int ;[out] int )
"MoveEndpointByUnit hresult(long;long;int;int*);" & _ ;MoveEndpointByUnit hresult([in] TextPatternRangeEndpoint ;[in] TextUnit ;[in] int ;[out] int )
"MoveEndpointByRange hresult(long;ptr;long);" & _ ;MoveEndpointByRange hresult([in] TextPatternRangeEndpoint ;[in] IUIAutomationTextRange *;[in] TextPatternRangeEndpoint )
"Select hresult();" & _ ;Select hresult()
"AddToSelection hresult();" & _ ;AddToSelection hresult()
"RemoveFromSelection hresult();" & _ ;RemoveFromSelection hresult()
"ScrollIntoView hresult(long);" & _ ;ScrollIntoView hresult([in] int )
"GetChildren hresult(ptr*);" ;GetChildren hresult([out] IUIAutomationElementArray **)
;===============================================================================
;list
Global $ltagIUIAutomationTextRange = $ltagIUnknown & _
"Clone;" & _ 
"Compare;" & _ 
"CompareEndpoints;" & _ 
"ExpandToEnclosingUnit;" & _ 
"FindAttribute;" & _ 
"FindText;" & _ 
"GetAttributeValue;" & _ 
"GetBoundingRectangles;" & _ 
"GetEnclosingElement;" & _ 
"GetText;" & _ 
"Move;" & _ 
"MoveEndpointByUnit;" & _ 
"MoveEndpointByRange;" & _ 
"Select;" & _ 
"AddToSelection;" & _ 
"RemoveFromSelection;" & _ 
"ScrollIntoView;" & _ 
"GetChildren;" 

;===============================================================================
Global Const $sIID_IUIAutomationTextRangeArray="{CE4AE76A-E717-4C98-81EA-47371D028EB6}"
Global Const $cIID_IUIAutomationTextRangeArray=_AutoItObject_CLSIDFromString($sIID_IUIAutomationTextRangeArray)
Global $dtagIUIAutomationTextRangeArray = $dtagIUnknown & _
"Length hresult(int*);" & _ ;Length hresult([out] int )
"GetElement hresult(int;ptr*);" ;GetElement hresult([in] int ;[out] IUIAutomationTextRange **)
;===============================================================================
;list
Global $ltagIUIAutomationTextRangeArray = $ltagIUnknown & _
"Length;" & _ 
"GetElement;" 

;===============================================================================
Global Const $sIID_IUIAutomationTextPattern="{32EBA289-3583-42C9-9C59-3B6D9A1E9B6A}"
Global Const $cIID_IUIAutomationTextPattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationTextPattern)
Global $dtagIUIAutomationTextPattern = $dtagIUnknown & _
"RangeFromPoint hresult(none;ptr*);" & _ ;RangeFromPoint hresult([in] tagPOINT ;[out] IUIAutomationTextRange **)
"RangeFromChild hresult(ptr;ptr*);" & _ ;RangeFromChild hresult([in] IUIAutomationElement *;[out] IUIAutomationTextRange **)
"GetSelection hresult(ptr*);" & _ ;GetSelection hresult([out] IUIAutomationTextRangeArray **)
"GetVisibleRanges hresult(ptr*);" & _ ;GetVisibleRanges hresult([out] IUIAutomationTextRangeArray **)
"DocumentRange hresult(ptr*);" & _ ;DocumentRange hresult([out] IUIAutomationTextRange **)
"SupportedTextSelection hresult(long*);" ;SupportedTextSelection hresult([out] SupportedTextSelection *)
;===============================================================================
;list
Global $ltagIUIAutomationTextPattern = $ltagIUnknown & _
"RangeFromPoint;" & _ 
"RangeFromChild;" & _ 
"GetSelection;" & _ 
"GetVisibleRanges;" & _ 
"DocumentRange;" & _ 
"SupportedTextSelection;" 

;===============================================================================
Global Const $sIID_IUIAutomationLegacyIAccessiblePattern="{828055AD-355B-4435-86D5-3B51C14A9B1B}"
Global Const $cIID_IUIAutomationLegacyIAccessiblePattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationLegacyIAccessiblePattern)
Global $dtagIUIAutomationLegacyIAccessiblePattern = $dtagIUnknown & _
"Select hresult(long);" & _ ;Select hresult(int )
"DoDefaultAction hresult();" & _ ;DoDefaultAction hresult()
"SetValue hresult(wstr);" & _ ;SetValue hresult(wstr )
"CurrentChildId hresult(int*);" & _ ;CurrentChildId hresult([out] int )
"CurrentName hresult(bstr*);" & _ ;CurrentName hresult([out] bstr )
"CurrentValue hresult(bstr*);" & _ ;CurrentValue hresult([out] bstr )
"CurrentDescription hresult(bstr*);" & _ ;CurrentDescription hresult([out] bstr )
"CurrentRole hresult(uint*);" & _ ;CurrentRole hresult([out] dword )
"CurrentState hresult(uint*);" & _ ;CurrentState hresult([out] dword )
"CurrentHelp hresult(bstr*);" & _ ;CurrentHelp hresult([out] bstr )
"CurrentKeyboardShortcut hresult(bstr*);" & _ ;CurrentKeyboardShortcut hresult([out] bstr )
"GetCurrentSelection hresult(ptr*);" & _ ;GetCurrentSelection hresult([out] IUIAutomationElementArray **)
"CurrentDefaultAction hresult(bstr*);" & _ ;CurrentDefaultAction hresult([out] bstr )
"CachedChildId hresult(int*);" & _ ;CachedChildId hresult([out] int )
"CachedName hresult(bstr*);" & _ ;CachedName hresult([out] bstr )
"CachedValue hresult(bstr*);" & _ ;CachedValue hresult([out] bstr )
"CachedDescription hresult(bstr*);" & _ ;CachedDescription hresult([out] bstr )
"CachedRole hresult(uint*);" & _ ;CachedRole hresult([out] dword )
"CachedState hresult(uint*);" & _ ;CachedState hresult([out] dword )
"CachedHelp hresult(bstr*);" & _ ;CachedHelp hresult([out] bstr )
"CachedKeyboardShortcut hresult(bstr*);" & _ ;CachedKeyboardShortcut hresult([out] bstr )
"GetCachedSelection hresult(ptr*);" & _ ;GetCachedSelection hresult([out] IUIAutomationElementArray **)
"CachedDefaultAction hresult(bstr*);" & _ ;CachedDefaultAction hresult([out] bstr )
"GetIAccessible hresult(none*);" ;GetIAccessible hresult([out] IAccessible **)
;===============================================================================
;list
Global $ltagIUIAutomationLegacyIAccessiblePattern = $ltagIUnknown & _
"Select;" & _ 
"DoDefaultAction;" & _ 
"SetValue;" & _ 
"CurrentChildId;" & _ 
"CurrentName;" & _ 
"CurrentValue;" & _ 
"CurrentDescription;" & _ 
"CurrentRole;" & _ 
"CurrentState;" & _ 
"CurrentHelp;" & _ 
"CurrentKeyboardShortcut;" & _ 
"GetCurrentSelection;" & _ 
"CurrentDefaultAction;" & _ 
"CachedChildId;" & _ 
"CachedName;" & _ 
"CachedValue;" & _ 
"CachedDescription;" & _ 
"CachedRole;" & _ 
"CachedState;" & _ 
"CachedHelp;" & _ 
"CachedKeyboardShortcut;" & _ 
"GetCachedSelection;" & _ 
"CachedDefaultAction;" & _ 
"GetIAccessible;" 

;===============================================================================
Global Const $sIID_IAccessible="{618736E0-3C3D-11CF-810C-00AA00389B71}"
Global Const $cIID_IAccessible=_AutoItObject_CLSIDFromString($sIID_IAccessible)
Global $dtagIAccessible = $dtagIUnknown & _
"accParent hresult(idispatch*);" & _ ;accParent hresult([out] idispatch )
"accChildCount hresult(long*);" & _ ;accChildCount hresult([out] int )
"accChild hresult(variant;idispatch*);" & _ ;accChild hresult([in] variant ;[out] idispatch )
"accName hresult(variant;bstr*);" & _ ;accName hresult([in] variant ;[out] bstr )
"accValue hresult(variant;bstr*);" & _ ;accValue hresult([in] variant ;[out] bstr )
"accDescription hresult(variant;bstr*);" & _ ;accDescription hresult([in] variant ;[out] bstr )
"accRole hresult(variant;variant*);" & _ ;accRole hresult([in] variant ;[out] variant )
"accState hresult(variant;variant*);" & _ ;accState hresult([in] variant ;[out] variant )
"accHelp hresult(variant;bstr*);" & _ ;accHelp hresult([in] variant ;[out] bstr )
"accHelpTopic hresult(bstr*;variant;long*);" & _ ;accHelpTopic hresult([out] bstr ;[in] variant ;[out] int )
"accKeyboardShortcut hresult(variant;bstr*);" & _ ;accKeyboardShortcut hresult([in] variant ;[out] bstr )
"accFocus hresult(variant*);" & _ ;accFocus hresult([out] variant )
"accSelection hresult(variant*);" & _ ;accSelection hresult([out] variant )
"accDefaultAction hresult(variant;bstr*);" & _ ;accDefaultAction hresult([in] variant ;[out] bstr )
"accSelect hresult(long;variant);" & _ ;accSelect hresult([in] int ;[in] variant )
"accLocation hresult(long*;long*;long*;long*;variant);" & _ ;accLocation hresult([out] int ;[out] int ;[out] int ;[out] int ;[in] variant )
"accNavigate hresult(long;variant;variant*);" & _ ;accNavigate hresult([in] int ;[in] variant ;[out] variant )
"accHitTest hresult(long;long;variant*);" & _ ;accHitTest hresult([in] int ;[in] int ;[out] variant )
"accDoDefaultAction hresult(variant);" & _ ;accDoDefaultAction hresult([in] variant )
"accName hresult(variant;bstr);" & _ ;accName hresult([in] variant ;[in] bstr )
"accValue hresult(variant;bstr);" ;accValue hresult([in] variant ;[in] bstr )
;===============================================================================
;list
Global $ltagIAccessible = $ltagIUnknown & _
"accParent;" & _ 
"accChildCount;" & _ 
"accChild;" & _ 
"accName;" & _ 
"accValue;" & _ 
"accDescription;" & _ 
"accRole;" & _ 
"accState;" & _ 
"accHelp;" & _ 
"accHelpTopic;" & _ 
"accKeyboardShortcut;" & _ 
"accFocus;" & _ 
"accSelection;" & _ 
"accDefaultAction;" & _ 
"accSelect;" & _ 
"accLocation;" & _ 
"accNavigate;" & _ 
"accHitTest;" & _ 
"accDoDefaultAction;" & _ 
"accName;" & _ 
"accValue;" 

;===============================================================================
Global Const $sIID_IUIAutomationItemContainerPattern="{C690FDB2-27A8-423C-812D-429773C9084E}"
Global Const $cIID_IUIAutomationItemContainerPattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationItemContainerPattern)
Global $dtagIUIAutomationItemContainerPattern = $dtagIUnknown & _
"FindItemByProperty hresult(ptr;int;variant;ptr*);" ;FindItemByProperty hresult([in] IUIAutomationElement *;[in] int ;[in] variant ;[out] IUIAutomationElement **)
;===============================================================================
;list
Global $ltagIUIAutomationItemContainerPattern = $ltagIUnknown & _
"FindItemByProperty;" 

;===============================================================================
Global Const $sIID_IUIAutomationVirtualizedItemPattern="{6BA3D7A6-04CF-4F11-8793-A8D1CDE9969F}"
Global Const $cIID_IUIAutomationVirtualizedItemPattern=_AutoItObject_CLSIDFromString($sIID_IUIAutomationVirtualizedItemPattern)
Global $dtagIUIAutomationVirtualizedItemPattern = $dtagIUnknown & _
"Realize hresult();" ;Realize hresult()
;===============================================================================
;list
Global $ltagIUIAutomationVirtualizedItemPattern = $ltagIUnknown & _
"Realize;" 

;===============================================================================
Global Const $sIID_IUIAutomationProxyFactory="{85B94ECD-849D-42B6-B94D-D6DB23FDF5A4}"
Global Const $cIID_IUIAutomationProxyFactory=_AutoItObject_CLSIDFromString($sIID_IUIAutomationProxyFactory)
Global $dtagIUIAutomationProxyFactory = $dtagIUnknown & _
"CreateProvider hresult(none;long;long;ptr*);" & _ ;CreateProvider hresult([in] void ;[in] int ;[in] int ;[out] IRawElementProviderSimple **)
"ProxyFactoryId hresult(bstr*);" ;ProxyFactoryId hresult([out] bstr )
;===============================================================================
;list
Global $ltagIUIAutomationProxyFactory = $ltagIUnknown & _
"CreateProvider;" & _ 
"ProxyFactoryId;" 

;===============================================================================
Global Const $sIID_IRawElementProviderSimple="{D6DD68D1-86FD-4332-8666-9ABEDEA2D24C}"
Global Const $cIID_IRawElementProviderSimple=_AutoItObject_CLSIDFromString($sIID_IRawElementProviderSimple)
Global $dtagIRawElementProviderSimple = $dtagIUnknown & _
"ProviderOptions hresult(long*);" & _ ;ProviderOptions hresult([out] ProviderOptions *)
"GetPatternProvider hresult(int;ptr*);" & _ ;GetPatternProvider hresult([in] int ;[out] iunknown )
"GetPropertyValue hresult(int;variant*);" & _ ;GetPropertyValue hresult([in] int ;[out] variant )
"HostRawElementProvider hresult(ptr*);" ;HostRawElementProvider hresult([out] IRawElementProviderSimple **)
;===============================================================================
;list
Global $ltagIRawElementProviderSimple = $ltagIUnknown & _
"ProviderOptions;" & _ 
"GetPatternProvider;" & _ 
"GetPropertyValue;" & _ 
"HostRawElementProvider;" 

;===============================================================================
Global Const $sIID_IUIAutomationProxyFactoryEntry="{D50E472E-B64B-490C-BCA1-D30696F9F289}"
Global Const $cIID_IUIAutomationProxyFactoryEntry=_AutoItObject_CLSIDFromString($sIID_IUIAutomationProxyFactoryEntry)
Global $dtagIUIAutomationProxyFactoryEntry = $dtagIUnknown & _
"ProxyFactory hresult(ptr*);" & _ ;ProxyFactory hresult([out] IUIAutomationProxyFactory **)
"ClassName hresult(bstr*);" & _ ;ClassName hresult([out] bstr )
"ImageName hresult(bstr*);" & _ ;ImageName hresult([out] bstr )
"AllowSubstringMatch hresult(long*);" & _ ;AllowSubstringMatch hresult([out] int )
"CanCheckBaseClass hresult(long*);" & _ ;CanCheckBaseClass hresult([out] int )
"NeedsAdviseEvents hresult(long*);" & _ ;NeedsAdviseEvents hresult([out] int )
"ClassName hresult(wstr);" & _ ;ClassName hresult([in] wstr )
"ImageName hresult(wstr);" & _ ;ImageName hresult([in] wstr )
"AllowSubstringMatch hresult(long);" & _ ;AllowSubstringMatch hresult([in] int )
"CanCheckBaseClass hresult(long);" & _ ;CanCheckBaseClass hresult([in] int )
"NeedsAdviseEvents hresult(long);" & _ ;NeedsAdviseEvents hresult([in] int )
"SetWinEventsForAutomationEvent hresult(int;int;ptr);" & _ ;SetWinEventsForAutomationEvent hresult([in] int ;[in] int ;[in] ne )
"GetWinEventsForAutomationEvent hresult(int;int;ptr*);" ;GetWinEventsForAutomationEvent hresult([in] int ;[in] int ;[out] ne )
;===============================================================================
;list
Global $ltagIUIAutomationProxyFactoryEntry = $ltagIUnknown & _
"ProxyFactory;" & _ 
"ClassName;" & _ 
"ImageName;" & _ 
"AllowSubstringMatch;" & _ 
"CanCheckBaseClass;" & _ 
"NeedsAdviseEvents;" & _ 
"ClassName;" & _ 
"ImageName;" & _ 
"AllowSubstringMatch;" & _ 
"CanCheckBaseClass;" & _ 
"NeedsAdviseEvents;" & _ 
"SetWinEventsForAutomationEvent;" & _ 
"GetWinEventsForAutomationEvent;" 

;===============================================================================
Global Const $sIID_IUIAutomationProxyFactoryMapping="{09E31E18-872D-4873-93D1-1E541EC133FD}"
Global Const $cIID_IUIAutomationProxyFactoryMapping=_AutoItObject_CLSIDFromString($sIID_IUIAutomationProxyFactoryMapping)
Global $dtagIUIAutomationProxyFactoryMapping = $dtagIUnknown & _
"count hresult(uint*);" & _ ;count hresult([out] dword )
"GetTable hresult(ptr*);" & _ ;GetTable hresult([out] IUIAutomationProxyFactoryEntry *)
"GetEntry hresult(uint;ptr*);" & _ ;GetEntry hresult([in] dword ;[out] IUIAutomationProxyFactoryEntry **)
"SetTable hresult(ptr);" & _ ;SetTable hresult([in] IUIAutomationProxyFactoryEntry )
"InsertEntries hresult(uint;ptr);" & _ ;InsertEntries hresult([in] dword ;[in] IUIAutomationProxyFactoryEntry )
"InsertEntry hresult(uint;ptr);" & _ ;InsertEntry hresult([in] dword ;[in] IUIAutomationProxyFactoryEntry *)
"RemoveEntry hresult(uint);" & _ ;RemoveEntry hresult([in] dword )
"ClearTable hresult();" & _ ;ClearTable hresult()
"RestoreDefaultTable hresult();" ;RestoreDefaultTable hresult()
;===============================================================================
;list
Global $ltagIUIAutomationProxyFactoryMapping = $ltagIUnknown & _
"count;" & _ 
"GetTable;" & _ 
"GetEntry;" & _ 
"SetTable;" & _ 
"InsertEntries;" & _ 
"InsertEntry;" & _ 
"RemoveEntry;" & _ 
"ClearTable;" & _ 
"RestoreDefaultTable;" 

;===============================================================================
Global Const $sIID_IUIAutomation="{30CBE57D-D9D0-452A-AB13-7AC5AC4825EE}"
Global Const $cIID_IUIAutomation=_AutoItObject_CLSIDFromString($sIID_IUIAutomation)
Global $dtagIUIAutomation = $dtagIUnknown & _
"CompareElements hresult(ptr;ptr;long*);" & _ ;CompareElements hresult([in] IUIAutomationElement *;[in] IUIAutomationElement *;[out] int )
"CompareRuntimeIds hresult(ptr;ptr;long*);" & _ ;CompareRuntimeIds hresult([in] ne ;[in] ne ;[out] int )
"GetRootElement hresult(ptr*);" & _ ;GetRootElement hresult([out] IUIAutomationElement **)
"ElementFromHandle hresult(none;ptr*);" & _ ;ElementFromHandle hresult([in] void ;[out] IUIAutomationElement **)
"ElementFromPoint hresult(none;ptr*);" & _ ;ElementFromPoint hresult([in] tagPOINT ;[out] IUIAutomationElement **)
"GetFocusedElement hresult(ptr*);" & _ ;GetFocusedElement hresult([out] IUIAutomationElement **)
"GetRootElementBuildCache hresult(ptr;ptr*);" & _ ;GetRootElementBuildCache hresult([in] IUIAutomationCacheRequest *;[out] IUIAutomationElement **)
"ElementFromHandleBuildCache hresult(none;ptr;ptr*);" & _ ;ElementFromHandleBuildCache hresult([in] void ;[in] IUIAutomationCacheRequest *;[out] IUIAutomationElement **)
"ElementFromPointBuildCache hresult(none;ptr;ptr*);" & _ ;ElementFromPointBuildCache hresult([in] tagPOINT ;[in] IUIAutomationCacheRequest *;[out] IUIAutomationElement **)
"GetFocusedElementBuildCache hresult(ptr;ptr*);" & _ ;GetFocusedElementBuildCache hresult([in] IUIAutomationCacheRequest *;[out] IUIAutomationElement **)
"CreateTreeWalker hresult(ptr;ptr*);" & _ ;CreateTreeWalker hresult([in] IUIAutomationCondition *;[out] IUIAutomationTreeWalker **)
"ControlViewWalker hresult(ptr*);" & _ ;ControlViewWalker hresult([out] IUIAutomationTreeWalker **)
"ContentViewWalker hresult(ptr*);" & _ ;ContentViewWalker hresult([out] IUIAutomationTreeWalker **)
"RawViewWalker hresult(ptr*);" & _ ;RawViewWalker hresult([out] IUIAutomationTreeWalker **)
"RawViewCondition hresult(ptr*);" & _ ;RawViewCondition hresult([out] IUIAutomationCondition **)
"ControlViewCondition hresult(ptr*);" & _ ;ControlViewCondition hresult([out] IUIAutomationCondition **)
"ContentViewCondition hresult(ptr*);" & _ ;ContentViewCondition hresult([out] IUIAutomationCondition **)
"CreateCacheRequest hresult(ptr*);" & _ ;CreateCacheRequest hresult([out] IUIAutomationCacheRequest **)
"CreateTrueCondition hresult(ptr*);" & _ ;CreateTrueCondition hresult([out] IUIAutomationCondition **)
"CreateFalseCondition hresult(ptr*);" & _ ;CreateFalseCondition hresult([out] IUIAutomationCondition **)
"CreatePropertyCondition hresult(int;variant;ptr*);" & _ ;CreatePropertyCondition hresult([in] int ;[in] variant ;[out] IUIAutomationCondition **)
"CreatePropertyConditionEx hresult(int;variant;long;ptr*);" & _ ;CreatePropertyConditionEx hresult([in] int ;[in] variant ;[in] PropertyConditionFlags ;[out] IUIAutomationCondition **)
"CreateAndCondition hresult(ptr;ptr;ptr*);" & _ ;CreateAndCondition hresult([in] IUIAutomationCondition *;[in] IUIAutomationCondition *;[out] IUIAutomationCondition **)
"CreateAndConditionFromArray hresult(ptr;ptr*);" & _ ;CreateAndConditionFromArray hresult([in] IUIAutomationCondition ;[out] IUIAutomationCondition **)
"CreateAndConditionFromNativeArray hresult(ptr;int;ptr*);" & _ ;CreateAndConditionFromNativeArray hresult([in] IUIAutomationCondition **;[in] int ;[out] IUIAutomationCondition **)
"CreateOrCondition hresult(ptr;ptr;ptr*);" & _ ;CreateOrCondition hresult([in] IUIAutomationCondition *;[in] IUIAutomationCondition *;[out] IUIAutomationCondition **)
"CreateOrConditionFromArray hresult(ptr;ptr*);" & _ ;CreateOrConditionFromArray hresult([in] IUIAutomationCondition ;[out] IUIAutomationCondition **)
"CreateOrConditionFromNativeArray hresult(ptr;int;ptr*);" & _ ;CreateOrConditionFromNativeArray hresult([in] IUIAutomationCondition **;[in] int ;[out] IUIAutomationCondition **)
"CreateNotCondition hresult(ptr;ptr*);" & _ ;CreateNotCondition hresult([in] IUIAutomationCondition *;[out] IUIAutomationCondition **)
"AddAutomationEventHandler hresult(int;ptr;long;ptr;ptr);" & _ ;AddAutomationEventHandler hresult([in] int ;[in] IUIAutomationElement *;[in] TreeScope ;[in] IUIAutomationCacheRequest *;[in] IUIAutomationEventHandler *)
"RemoveAutomationEventHandler hresult(int;ptr;ptr);" & _ ;RemoveAutomationEventHandler hresult([in] int ;[in] IUIAutomationElement *;[in] IUIAutomationEventHandler *)
"AddPropertyChangedEventHandlerNativeArray hresult(ptr;long;ptr;ptr;int;int);" & _ ;AddPropertyChangedEventHandlerNativeArray hresult([in] IUIAutomationElement *;[in] TreeScope ;[in] IUIAutomationCacheRequest *;[in] IUIAutomationPropertyChangedEventHandler *;[in] int ;[in] int )
"AddPropertyChangedEventHandler hresult(ptr;long;ptr;ptr;ptr);" & _ ;AddPropertyChangedEventHandler hresult([in] IUIAutomationElement *;[in] TreeScope ;[in] IUIAutomationCacheRequest *;[in] IUIAutomationPropertyChangedEventHandler *;[in] ne )
"RemovePropertyChangedEventHandler hresult(ptr;ptr);" & _ ;RemovePropertyChangedEventHandler hresult([in] IUIAutomationElement *;[in] IUIAutomationPropertyChangedEventHandler *)
"AddStructureChangedEventHandler hresult(ptr;long;ptr;ptr);" & _ ;AddStructureChangedEventHandler hresult([in] IUIAutomationElement *;[in] TreeScope ;[in] IUIAutomationCacheRequest *;[in] IUIAutomationStructureChangedEventHandler *)
"RemoveStructureChangedEventHandler hresult(ptr;ptr);" & _ ;RemoveStructureChangedEventHandler hresult([in] IUIAutomationElement *;[in] IUIAutomationStructureChangedEventHandler *)
"AddFocusChangedEventHandler hresult(ptr;ptr);" & _ ;AddFocusChangedEventHandler hresult([in] IUIAutomationCacheRequest *;[in] IUIAutomationFocusChangedEventHandler *)
"RemoveFocusChangedEventHandler hresult(ptr);" & _ ;RemoveFocusChangedEventHandler hresult([in] IUIAutomationFocusChangedEventHandler *)
"RemoveAllEventHandlers hresult();" & _ ;RemoveAllEventHandlers hresult()
"IntNativeArrayToSafeArray hresult(int;int;ptr*);" & _ ;IntNativeArrayToSafeArray hresult([in] int ;[in] int ;[out] ne )
"IntSafeArrayToNativeArray hresult(ptr;int*;int*);" & _ ;IntSafeArrayToNativeArray hresult([in] ne ;[out] int ;[out] int )
"RectToVariant hresult(none;variant*);" & _ ;RectToVariant hresult([in] tagRECT ;[out] variant )
"VariantToRect hresult(variant;none*);" & _ ;VariantToRect hresult([in] variant ;[out] tagRECT *)
"SafeArrayToRectNativeArray hresult(ptr;none*;int*);" & _ ;SafeArrayToRectNativeArray hresult([in] ne ;[out] tagRECT **;[out] int )
"CreateProxyFactoryEntry hresult(ptr;ptr*);" & _ ;CreateProxyFactoryEntry hresult([in] IUIAutomationProxyFactory *;[out] IUIAutomationProxyFactoryEntry **)
"ProxyFactoryMapping hresult(ptr*);" & _ ;ProxyFactoryMapping hresult([out] IUIAutomationProxyFactoryMapping **)
"GetPropertyProgrammaticName hresult(int;bstr*);" & _ ;GetPropertyProgrammaticName hresult([in] int ;[out] bstr )
"GetPatternProgrammaticName hresult(int;bstr*);" & _ ;GetPatternProgrammaticName hresult([in] int ;[out] bstr )
"PollForPotentialSupportedPatterns hresult(ptr;ptr*;ptr*);" & _ ;PollForPotentialSupportedPatterns hresult([in] IUIAutomationElement *;[out] ne ;[out] ne )
"PollForPotentialSupportedProperties hresult(ptr;ptr*;ptr*);" & _ ;PollForPotentialSupportedProperties hresult([in] IUIAutomationElement *;[out] ne ;[out] ne )
"CheckNotSupported hresult(variant;long*);" & _ ;CheckNotSupported hresult([in] variant ;[out] int )
"ReservedNotSupportedValue hresult(ptr*);" & _ ;ReservedNotSupportedValue hresult([out] iunknown )
"ReservedMixedAttributeValue hresult(ptr*);" & _ ;ReservedMixedAttributeValue hresult([out] iunknown )
"ElementFromIAccessible hresult(none;int;ptr*);" & _ ;ElementFromIAccessible hresult([in] IAccessible *;[in] int ;[out] IUIAutomationElement **)
"ElementFromIAccessibleBuildCache hresult(none;int;ptr;ptr*);" ;ElementFromIAccessibleBuildCache hresult([in] IAccessible *;[in] int ;[in] IUIAutomationCacheRequest *;[out] IUIAutomationElement **)
;===============================================================================
;list
Global $ltagIUIAutomation = $ltagIUnknown & _
"CompareElements;" & _ 
"CompareRuntimeIds;" & _ 
"GetRootElement;" & _ 
"ElementFromHandle;" & _ 
"ElementFromPoint;" & _ 
"GetFocusedElement;" & _ 
"GetRootElementBuildCache;" & _ 
"ElementFromHandleBuildCache;" & _ 
"ElementFromPointBuildCache;" & _ 
"GetFocusedElementBuildCache;" & _ 
"CreateTreeWalker;" & _ 
"ControlViewWalker;" & _ 
"ContentViewWalker;" & _ 
"RawViewWalker;" & _ 
"RawViewCondition;" & _ 
"ControlViewCondition;" & _ 
"ContentViewCondition;" & _ 
"CreateCacheRequest;" & _ 
"CreateTrueCondition;" & _ 
"CreateFalseCondition;" & _ 
"CreatePropertyCondition;" & _ 
"CreatePropertyConditionEx;" & _ 
"CreateAndCondition;" & _ 
"CreateAndConditionFromArray;" & _ 
"CreateAndConditionFromNativeArray;" & _ 
"CreateOrCondition;" & _ 
"CreateOrConditionFromArray;" & _ 
"CreateOrConditionFromNativeArray;" & _ 
"CreateNotCondition;" & _ 
"AddAutomationEventHandler;" & _ 
"RemoveAutomationEventHandler;" & _ 
"AddPropertyChangedEventHandlerNativeArray;" & _ 
"AddPropertyChangedEventHandler;" & _ 
"RemovePropertyChangedEventHandler;" & _ 
"AddStructureChangedEventHandler;" & _ 
"RemoveStructureChangedEventHandler;" & _ 
"AddFocusChangedEventHandler;" & _ 
"RemoveFocusChangedEventHandler;" & _ 
"RemoveAllEventHandlers;" & _ 
"IntNativeArrayToSafeArray;" & _ 
"IntSafeArrayToNativeArray;" & _ 
"RectToVariant;" & _ 
"VariantToRect;" & _ 
"SafeArrayToRectNativeArray;" & _ 
"CreateProxyFactoryEntry;" & _ 
"ProxyFactoryMapping;" & _ 
"GetPropertyProgrammaticName;" & _ 
"GetPatternProgrammaticName;" & _ 
"PollForPotentialSupportedPatterns;" & _ 
"PollForPotentialSupportedProperties;" & _ 
"CheckNotSupported;" & _ 
"ReservedNotSupportedValue;" & _ 
"ReservedMixedAttributeValue;" & _ 
"ElementFromIAccessible;" & _ 
"ElementFromIAccessibleBuildCache;" 

;===============================================================================
