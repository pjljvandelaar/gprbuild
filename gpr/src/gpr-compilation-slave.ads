------------------------------------------------------------------------------
--                                                                          --
--                           GPR PROJECT MANAGER                            --
--                                                                          --
--          Copyright (C) 2012-2017, Free Software Foundation, Inc.         --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

with GNAT.OS_Lib;
with GPR.Compilation.Protocol;

package GPR.Compilation.Slave is

   use GPR.Compilation;
   use GPR.Compilation.Protocol;

   procedure Record_Slaves (Option : String);
   --  Record the slaves as passed on the command line

   procedure Register_Remote_Slaves
     (Tree    : Project_Tree_Ref;
      Project : Project_Id);
   --  Register the slaves describes in Build_Slaves attribute of project's
   --  Remote package. This routine also initialize the slaves sources. This
   --  routine must be called before any other in this unit.

   function Channel (Host : String) return Protocol.Communication_Channel;
   --  Returns the communication channel for the given host. Returns No_Channel
   --  if host has not been registered.

   procedure Clean_Up_Remote_Slaves
     (Tree    : Project_Tree_Ref;
      Project : Project_Id);
   --  Send a clean-up request to all remote slaves. The slaves are then asked
   --  to remove all the sources and build artifacts for the given project.

   function Run
     (Project  : Project_Id;
      Language : String;
      Options  : GNAT.OS_Lib.Argument_List;
      Obj_Name : String;
      Dep_Name : String := "";
      Env      : String := "") return Id;
   --  Send a compilation job to one slave that has still some free slot. There
   --  is also free slot when this routine is called (gprbuild ensure this).

   procedure Unregister_Remote_Slaves (From_Signal : Boolean := False);
   --  Unregister all slaves, send them notification about the end of the
   --  current build. This routine must be called after the compilation phase
   --  and before the bind and link ones. It is safe to call this routine
   --  multiple times, the first call will do the clean-up, next calls are
   --  just no-op. From_Signal must be set when called from a signal, for
   --  example when calling this routine from the ctrl-c handler.

   function Get_Max_Processes return Natural;
   --  Returns the maximum number of processes supported by the compilation
   --  engine. This is the sum of the parallel local builds as specified by
   --  the -j option and all the sum of the processes supported by each slaves.

end GPR.Compilation.Slave;
