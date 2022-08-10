; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; AUTOMATICALLY GENERATED CODE, DO NOT MODIFY
; UNLESS YOU REALLY, REALLY, REALLY MEAN IT !!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Code generated by : Dev-Object - V1.4.8
; Project name : OpenGL 3D Game Tutorial
; File name : TinyMersenneTwister.pbi
; File Version : 0.0.0
; Programmation : In progress
; Programmed by : Guillaume Saumure
; AKA : StarBootics
; E-mail : gsaumure@cgocable.ca
; Creation Date : May 5th, 2021
; Last update : July 30th, 2022
; Coded for PureBasic : V6.00 LTS
; Platform : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
; 3-clause BSD License
; 
; Copyright (c) 2011, 2013 Mutsuo Saito, Makoto Matsumoto,
; Hiroshima University and The University of Tokyo.
; All rights reserved.
; 
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are
; met:
; 
;     * Redistributions of source code must retain the above copyright
;       notice, this list of conditions and the following disclaimer.
;     * Redistributions in binary form must reproduce the above
;       copyright notice, this list of conditions and the following
;       disclaimer in the documentation and/or other materials provided
;       with the distribution.
;     * Neither the name of the Hiroshima University nor the names of
;       its contributors may be used to endorse or promote products
;       derived from this software without specific prior written
;       permission.
; 
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
; A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
; OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
; SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
; LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
; DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
; THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
; OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

DeclareModule TinyMersenneTwister
  
  Interface TinyMersenneTwister
    
    SetSeed(Seed.l)
    RandomInt()
    RandomFloat.f()
    Free()
    
  EndInterface
  
  Declare.i New(Seed.l)
  
EndDeclareModule

Module TinyMersenneTwister
  
  #MEXP = 127
  #MIN_LOOP = 8
  #PRE_LOOP = 8
  #MASK = $7FFFFFFF
  #SH0 = 1
  #SH1 = 10
  #SH8 = 8
  #MUL = 1.0 / 16777216.0
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Structures Declaration <<<<<
  
  Structure Conv
    
    StructureUnion
      u.q
      f.f
    EndStructureUnion
    
  EndStructure
  
  Structure Private_Members
    
    VirtualTable.i
    Status.q[4]
    Mat1.q
    Mat2.q
    TMat.q
    
  EndStructure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Helper Macro <<<<<
  
  Macro U32V(v)
    
    ((v) & $FFFFFFFF)
    
  EndMacro
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Private Support procedures <<<<<
  
  Procedure Private_NextState(*This.Private_Members)
    
    Protected x.q, y.q, a.q, b.q
    
    y = *This\Status[3]
    x = U32V((*This\Status[0] & #MASK) ! *This\Status[1] ! *This\Status[2])
    
    x = U32V(x ! (x << #SH0))
    y = U32V(y ! (y >> #SH0) ! x)
    
    *This\Status[0] = *This\Status[1]
    *This\Status[1] = *This\Status[2]
    *This\Status[2] = U32V(x ! (y << #SH1))
    *This\Status[3] = y
    
    a = -(y & 1) & *This\Mat1
    b = -(y & 1) & *This\Mat2
    
    *This\Status[1] = *This\Status[1] ! U32V(a)
    *This\Status[2] = *This\Status[2] ! U32V(b)
    
  EndProcedure
  
  Procedure.q Private_Temper(*This.Private_Members, Linearity_Check.i = #False)
    
    t0.q = *This\Status[3]
    
    If Linearity_Check = #True
      t1.q = U32V(*This\Status[0] ! (*This\Status[2] >> #SH8))
    Else
      t1.q = U32V(*This\Status[0] + (*This\Status[2] >> #SH8))
    EndIf
    
    t0 = U32V(t0 ! t1)
    
    If (t1 & 1) <> 0
      t0 = U32V(t0 ! *This\TMat)
    EndIf
    
    ProcedureReturn t0
  EndProcedure
  
  Procedure Private_Period_Certification(*This.Private_Members)
    
    If (*This\Status[0] & #MASK) = 0 And *This\Status[1] = 0 And *This\Status[2] = 0 And *This\Status[3] = 0
      *This\Status[0] = 'T'
      *This\Status[1] = 'I'
      *This\Status[2] = 'N'
      *This\Status[3] = 'Y'
    EndIf
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< THe SetSeed mutator <<<<<
  
  Procedure SetSeed(*This.Private_Members, Seed.l)
    
    *This\Status[0] = Seed
    *This\Status[1] = *This\Mat1
    *This\Status[2] = *This\Mat2
    *This\Status[3] = *This\TMat
    
    For Index = 0 To #MIN_LOOP - 1
      *This\Status[Index & 3] = U32V(*This\Status[Index & 3] ! U32V(Index + U32V(1812433253) * (*This\Status[(Index-1) & 3]) ! U32V(*This\Status[(Index-1) & 3] >> 30)))
    Next
    
    Private_Period_Certification(*This)
    
    For Index = 0 To #PRE_LOOP - 1
      Private_NextState(*This)
    Next
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Generate a Random Integer <<<<<
  
  Procedure.q RandomInt(*This.Private_Members)
    
    Private_NextState(*This)
    
    ProcedureReturn U32V(Private_Temper(*This, #False))
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Generate a Random Float <<<<<
  
  Procedure.f RandomFloat(*This.Private_Members)
    
    Private_NextState(*This)
    
    Value.q = Private_Temper(*This, #False) >> 8
    
    ProcedureReturn Value * #MUL
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Destructor <<<<<

  Procedure Free(*This.Private_Members)
    
    FreeStructure(*This)
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Constructor <<<<<

  Procedure.i New(Seed.l)
    
    *This.Private_Members = AllocateStructure(Private_Members)
    *This\VirtualTable = ?START_METHODS
    
    *This\Mat1 = U32V($8F7011EE)
    *This\Mat2 = U32V($FC78FF1F)
    *This\TMat = U32V($3793FDFF)
    
    SetSeed(*This, Seed)
    
    ProcedureReturn *This
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< The Virtual Table Entries <<<<<

  DataSection
    START_METHODS:
    Data.i @SetSeed()
    Data.i @RandomInt()
    Data.i @RandomFloat()
    Data.i @Free()
    END_METHODS:
  EndDataSection
  
EndModule

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Code generated in : 00.001 seconds (81000.00 lines/second) <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<
; <<<<< END OF FILE <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 6.00 LTS (Linux - x64)
; Folding = ---
; EnableXP
; CompileSourceDirectory