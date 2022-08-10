; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Project Name : Multi-Language Management
; File Name : Language - OOP.pb
; File Version : 1.0.0
; Programming : OK
; Programmed by : Guillaume Saumure
; AKA : StarBootics
; Email : gsaumure@cgocable.ca
; Date : 25-03-2022
; Update : 25-03-2022
; Coded for PureBasic : V6.00 Beta 5
; Platform : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; The MIT License (MIT)
; 
; Copyright (c) 2022 Guillaume Saumure
; 
; Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
; associated documentation files (the "Software"), to deal in the Software without restriction, including 
; without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
; copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the 
; following conditions:
; 
; The above copyright notice and this permission notice shall be included in all copies or substantial 
; portions of the Software.
; 
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
; LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO 
; EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
; IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR 
; THE USE OR OTHER DEALINGS IN THE SOFTWARE.
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

DeclareModule Language
  
  Interface Language
    
    GetPathName.s()
    GetFileName.s()
    SetFileName(FileName.s)
    LoadTableFile()
    Message.s(Message.s)
    
    CompilerIf #PB_Compiler_Debugger
      CreateTableFile()
      AddTableElement(Key.s, Message.s)
    CompilerEndIf
    
    CompilerIf Defined(CustomPrefs, #PB_Module)
      AddPrefsGroup(GroupName.s, *CustomPrefs.CustomPrefs::CustomPrefs)
      ExtractPrefsGroup(GroupName.s, *CustomPrefs.CustomPrefs::CustomPrefs)
      RefreshPrefsGroup(GroupName.s, *CustomPrefs.CustomPrefs::CustomPrefs)
    CompilerEndIf
    
    Free()
    
  EndInterface
  
  Declare.i New(PathName.s, FileName.s)
  
EndDeclareModule

Module Language
  
  Structure Private_Members
    
    VirtualTable.i
    PathName.s
    FileName.s
    Map Table.s()
    
  EndStructure
  
  Procedure GetLanguageXMLNode(*This.Private_Members, CurrentNode.i)
    
    If ParentXMLNode(CurrentNode) = #Null
      StructNode = ChildXMLNode(CurrentNode)
      If GetXMLNodeName(StructNode) = "Language"
        Success = #True
      EndIf
    Else
      Success = #True
      StructNode = CurrentNode
    EndIf
    
    If Success = #True
      
      FieldNode = ChildXMLNode(StructNode)
      
      While FieldNode
        
        Select GetXMLNodeName(FieldNode)
            
          Case "Table"
            Table_Max = Val(GetXMLAttribute(FieldNode, "ElementCount"))
            
            For Element = 0 To Table_Max - 1
              IndexNode = ChildXMLNode(FieldNode, Element + 1)
              If GetXMLNodeName(IndexNode) = "Element"
                *This\Table(GetXMLAttribute(IndexNode, "Key")) = GetXMLAttribute(IndexNode, "Translation")
              EndIf
            Next
            
        EndSelect
        
        FieldNode = NextXMLNode(FieldNode)
        
      Wend
      
    EndIf
    
  EndProcedure 
  
  Procedure.s GetPathName(*This.Private_Members)
    
    ProcedureReturn *This\PathName
  EndProcedure
  
  Procedure.s GetFileName(*This.Private_Members)
    
    ProcedureReturn *This\FileName
  EndProcedure
  
  Procedure SetFileName(*This.Private_Members, FileName.s)
    
    *This\FileName = FileName
    
  EndProcedure
  
  Procedure LoadTableFile(*This.Private_Members)
    
    FileID = LoadXML(#PB_Any, *This\PathName + *This\FileName)
    
    If IsXML(FileID)
      ClearMap(*This\Table())
      FormatXML(FileID, #PB_XML_CutNewline)
      GetLanguageXMLNode(*This, RootXMLNode(FileID))
      FreeXML(FileID)
    EndIf
    
  EndProcedure
  
  Procedure.s Message(*This.Private_Members, Message.s)
    
    If FindMapElement(*This\Table(), Message)
      Message_Out.s = *This\Table(Message)
    Else
      Message_Out = Message
    EndIf
    
    ProcedureReturn Message_Out
  EndProcedure
  
  CompilerIf #PB_Compiler_Debugger
    
    ; These procedures only exist to create default language files
    ; and they are created only when the main program is compiled
    ; with the debugger active.
    
    Procedure SetLanguageXMLNode(*This.Private_Members, CurrentNode)
      
      If ParentXMLNode(CurrentNode) = #Null
        StructNode = CreateXMLNode(CurrentNode, "Language")
      Else
        StructNode = CurrentNode
      EndIf
      
      FieldNode = CreateXMLNode(StructNode, "Table")
      SetXMLAttribute(FieldNode, "ElementCount", Str(MapSize(*This\Table())))
      Element = 0
      
      ForEach *This\Table()
        IndexNode = CreateXMLNode(FieldNode, "Element")
        SetXMLAttribute(IndexNode, "Key", MapKey(*This\Table()))
        SetXMLAttribute(IndexNode, "Translation", *This\Table())
      Next
      
    EndProcedure
    
    Procedure CreateTableFile(*This.Private_Members)
      
      FileID = CreateXML(#PB_Any)
      
      If IsXML(FileID)
        SetLanguageXMLNode(*This, RootXMLNode(FileID))
        FormatXML(FileID, #PB_XML_ReFormat | #PB_XML_ReIndent)
        SaveXML(FileID, *This\PathName + *This\FileName)
        FreeXML(FileID)
      EndIf
      
    EndProcedure
    
    Procedure AddTableElement(*This.Private_Members, Key.s, Message.s)
      
      *This\Table(Key) = Message
      
    EndProcedure
    
  CompilerEndIf 
  
  CompilerIf Defined(CustomPrefs, #PB_Module)
    
    ; <<<<<<<<<<<<<<<<<<<<<<<<<<<
    ; <<<<< Add Prefs Group <<<<<
    
    Procedure AddPrefsGroup(*This.Private_Members, GroupName.s, *CustomPrefs.CustomPrefs::CustomPrefs)
      
      *CustomPrefs\AddGroup(GroupName)
      
      *CustomPrefs\AddKeyString(GroupName, "FileName", *This\FileName)
      
      *CustomPrefs\AddGroupEmptyLine(GroupName)
      
    EndProcedure
    
    ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ; <<<<< Extract Prefs Group <<<<<
    
    Procedure ExtractPrefsGroup(*This.Private_Members, GroupName.s, *CustomPrefs.CustomPrefs::CustomPrefs)
      
      If *CustomPrefs\IsGroup(GroupName)
        
        If *CustomPrefs\IsKey(GroupName, "FileName")
          *This\FileName = *CustomPrefs\GetValueString(GroupName, "FileName", *This\FileName)
        EndIf
        
      EndIf
      
    EndProcedure
    
    ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ; <<<<< Refresh Prefs Group <<<<<
    
    Procedure RefreshPrefsGroup(*This.Private_Members, GroupName.s, *CustomPrefs.CustomPrefs::CustomPrefs)
      
      If *CustomPrefs\IsGroup(GroupName)
        
        If *CustomPrefs\IsKey(GroupName, "FileName")
          *CustomPrefs\SetValueString(GroupName, "FileName", *This\FileName)
        EndIf
        
      EndIf
      
    EndProcedure
    
  CompilerEndIf
  
  Procedure Free(*This.Private_Members)
    
    FreeStructure(*This)
    
  EndProcedure
  
  Procedure.i New(PathName.s, FileName.s)
    
    *This.Private_Members = AllocateStructure(Private_Members)
    *This\VirtualTable = ?START_METHODS
    
    *This\PathName = PathName
    *This\FileName = FileName
    
    ProcedureReturn *This
  EndProcedure
  
  DataSection
    START_METHODS:
    Data.i @GetPathName()
    Data.i @GetFileName()
    Data.i @SetFileName()
    Data.i @LoadTableFile()
    Data.i @Message()
    
    CompilerIf #PB_Compiler_Debugger
      Data.i @CreateTableFile()
      Data.i @AddTableElement()
    CompilerEndIf
    
    CompilerIf Defined(CustomPrefs, #PB_Module)
      Data.i @AddPrefsGroup()
      Data.i @ExtractPrefsGroup()
      Data.i @RefreshPrefsGroup()
    CompilerEndIf
    
    Data.i @Free()
    END_METHODS:
  EndDataSection
  
EndModule

; <<<<<<<<<<<<<<<<<<<<<<<
; <<<<< END OF FILE <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 6.00 LTS (Linux - x64)
; Folding = -----
; EnableXP
; CompileSourceDirectory