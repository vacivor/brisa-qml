cmake_minimum_required(VERSION 3.16)

project(brisa_qml VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Svg)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appbrisa_qml
        examples/main.cpp
)

set_source_files_properties(qml/Brisa/ThemeStore.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(appbrisa_qml
    URI brisa_qml
    QML_FILES
        examples/Main.qml
        qml/Brisa/ThemeStore.qml
        qml/Brisa/Theme.qml
        qml/Brisa/LoadingSpinner.qml
        qml/Brisa/BrisaWave.qml
        qml/Brisa/BrisaRoundRect.qml
        qml/Brisa/BrisaRipple.qml
        qml/Brisa/IconSwitch.qml
        qml/Brisa/BrisaWrap.qml
        qml/Brisa/BrisaCard.qml
        qml/Brisa/BrisaPopup.qml
        qml/Brisa/BrisaTooltip.qml
        qml/Brisa/BrisaPopover.qml
        qml/Brisa/BrisaPopconfirm.qml
        qml/Brisa/BrisaPopselect.qml
        qml/Brisa/BrisaDropdown.qml
        qml/Brisa/BrisaModal.qml
        qml/Brisa/BrisaMessageBus.qml
        qml/Brisa/BrisaNotificationBus.qml
        qml/Brisa/BrisaDialog.qml
        qml/Brisa/BrisaDrawer.qml
        qml/Brisa/BrisaMenu.qml
        qml/Brisa/BrisaScrollBar.qml
        qml/Brisa/BrisaButtonGroup.qml
        qml/Brisa/BrisaButton.qml
        qml/Brisa/BrisaInput.qml
        qml/Brisa/BrisaInputNumber.qml
        qml/Brisa/BrisaSelect.qml
        qml/Brisa/BrisaTree.qml
        qml/Brisa/BrisaTreeNode.qml
        qml/Brisa/BrisaTreeSelect.qml
        qml/Brisa/BrisaTreeSelectNode.qml
        qml/Brisa/BrisaComboBox.qml
        qml/Brisa/BrisaTabPane.qml
        qml/Brisa/BrisaTabs.qml
        qml/Brisa/BrisaPagination.qml
        qml/Brisa/BrisaProgress.qml
        qml/Brisa/BrisaTag.qml
        qml/Brisa/BrisaInputGroup.qml
        qml/Brisa/BrisaInputGroupLabel.qml
        qml/Brisa/BrisaBreadcrumb.qml
        qml/Brisa/BrisaBreadcrumbItem.qml
        qml/Brisa/BrisaBadge.qml
        qml/Brisa/BrisaFloatButton.qml
        qml/Brisa/BrisaFloatButtonGroup.qml
        qml/Brisa/BrisaList.qml
        qml/Brisa/BrisaListItem.qml
        qml/Brisa/BrisaForm.qml
        qml/Brisa/BrisaFormItem.qml
        qml/Brisa/BrisaFormGroup.qml
        qml/Brisa/BrisaSwitch.qml
        qml/Brisa/BrisaIcon.qml
        qml/Brisa/BrisaIconWrapper.qml
        qml/Brisa/BrisaSpin.qml
        qml/Brisa/BrisaEmpty.qml
        qml/Brisa/BrisaDataTable.qml
        qml/Brisa/BrisaDivider.qml
        qml/Brisa/BrisaCollapse.qml
        qml/Brisa/BrisaCollapseItem.qml
        qml/Brisa/BrisaCheckbox.qml
        qml/Brisa/BrisaCheckboxGroup.qml
        qml/Brisa/BrisaRadio.qml
        qml/Brisa/BrisaRadioGroup.qml
        qml/Brisa/BrisaAlert.qml
        qml/Brisa/BrisaAvatar.qml
        qml/Brisa/BrisaAvatarGroup.qml
        examples/showcase/ShowcaseSection.qml
        examples/showcase/AvatarShowcase.qml
        examples/showcase/BadgeShowcase.qml
        examples/showcase/BreadcrumbShowcase.qml
        examples/showcase/FloatButtonShowcase.qml
        examples/showcase/ButtonShowcase.qml
        examples/showcase/ListShowcase.qml
        examples/showcase/LayoutShowcase.qml
        examples/showcase/MenuShowcase.qml
        examples/showcase/CardShowcase.qml
        examples/showcase/PopupShowcase.qml
        examples/showcase/InputShowcase.qml
        examples/showcase/InputNumberShowcase.qml
        examples/showcase/SelectShowcase.qml
        examples/showcase/TreeShowcase.qml
        examples/showcase/TreeSelectShowcase.qml
        examples/showcase/TabsShowcase.qml
        examples/showcase/PaginationShowcase.qml
        examples/showcase/ProgressShowcase.qml
        examples/showcase/TagShowcase.qml
        examples/showcase/FormShowcase.qml
        examples/showcase/SwitchShowcase.qml
        examples/showcase/IconShowcase.qml
        examples/showcase/SpinShowcase.qml
        examples/showcase/EmptyShowcase.qml
        examples/showcase/DataTableShowcase.qml
        examples/showcase/DividerShowcase.qml
        examples/showcase/CollapseShowcase.qml
        examples/showcase/CheckboxShowcase.qml
        examples/showcase/RadioShowcase.qml
        examples/showcase/AlertShowcase.qml
    SOURCES
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appbrisa_qml PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appbrisa_qml
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appbrisa_qml
    PRIVATE Qt6::Quick Qt6::Svg
)

include(GNUInstallDirs)
install(TARGETS appbrisa_qml
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
