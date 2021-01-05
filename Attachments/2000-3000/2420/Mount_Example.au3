#Include <MountInclude.au3>
_Mount (@MyDocumentsDir,"Z:") ; Mounts the my documents dir as drive Z
Sleep (30000)
_UnMount("Z:") ; UnMounts Z Drive
