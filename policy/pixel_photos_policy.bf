#=====================================================================
# PixelPhotosEvolved : Brainfuck upload identity and editing policy
#=====================================================================
#
# Generated source ; the rule table in the header is the readable form ;
# cell numbers below must be changed together with the generator
#
# INPUT ; exactly 11 bytes ; bytes past the eleventh are ignored
#   0 version       must be 1 ; otherwise everything passes through
#   1 operation     1 backup ; 2 boost preview ; 3 temp job ; 4 result ; 5 local offer
#   2 media class   0 plain ; 1 cover ; 2 and 3 main ; 4 unknown
#   3 workflow      0 unknown ; 1 metadata ok ; 2 temp ok ; 3 result ok
#   4 capability    0 unknown ; 1 native ok ; 2 modern verified
#   5 master        switch
#   6 Pixel XL      preference
#   7 smart         preference
#   8 boundary      scoped request construction verified
#   9 XL boundary   Pixel XL request boundary verified
#  10 editing       0 untested ; 1 native ; 2 verified override
#
# OUTPUT ; exactly 2 bytes ; written at the very end
#   0 policy   0 pass through ; 1 back up as Pixel XL ;
#              2 device native ; 3 modern Pixel compatibility ; 4 local offer eligibility
#   1 editing  0 none ; 1 native feature ; 2 override eligible
#
# RULE TABLE
#   policy 1 : version and master and Pixel XL and XL boundary
#              and either operation 1
#              or operation 2 with media class 1 and workflow 1
#              or operation 4 with class 3 workflow 3 smart and boundary
#   policy 2 or 3 : version and master and operation 3 and workflow 2
#              and smart and boundary and class in 2 or 3
#              and capability in 1 or 2 ; policy equals capability plus one
#   editing 1 or 2 : version is 1 and the editing byte is 1 or 2
#   every other input passes through ; malformed bytes included
#
# TAPE MAP ; 65536 wrapping 8 bit cells ; the pointer stays in range
#     0  V     ABI byte 0 : version ; must be exactly 1
#     1  VT    scratch for the version byte
#     2  V1    flag : version equals 1 ; used by the backup gate
#     3  V1B   flag : version equals 1 ; used by the temporary gate
#     4  V1C   flag : version equals 1 ; used by the editing gate
#     5  OP    ABI byte 1 : operation
#     6  OPT   scratch for the operation byte
#     7  OP1   flag : operation equals 1 ; ordinary backup
#     8  OP2   flag : operation equals 2 ; Video Boost preview
#     9  OP3   flag : operation equals 3 ; temporary processing
#    10  OP4   flag : operation equals 4 ; confirmed result
#    11  MC    ABI byte 2 : media class
#    12  MCT   scratch for the media class byte
#    13  MC1   flag : media class equals 1 ; cover of a Video Boost series
#    14  MC2   flag : media class equals 2 ; main item of a series
#    15  MC3A  flag : media class equals 3 ; processed main item
#    16  MC3B  flag : media class equals 3 ; second consumer
#    17  WS    ABI byte 3 : verified workflow state
#    18  WST   scratch for the workflow byte
#    19  WS1   flag : workflow state equals 1 ; metadata validated
#    20  WS2   flag : workflow state equals 2 ; temporary request confirmed
#    21  WS3   flag : workflow state equals 3 ; processed result confirmed
#    22  CAP   ABI byte 4 : capability
#    23  CAPT  scratch for the capability byte
#    24  CAP1  flag : capability equals 1 ; device native valid
#    25  CAP2  flag : capability equals 2 ; modern path verified
#    26  M     ABI byte 5 : master switch
#    27  MT    scratch for the master byte
#    28  M1    flag : master equals 1
#    29  M1B   flag : master equals 1 ; second consumer
#    30  X     ABI byte 6 : Pixel XL preference
#    31  XT    scratch for the Pixel XL byte
#    32  X1    flag : Pixel XL preference equals 1
#    33  S     ABI byte 7 : smart routing preference
#    34  ST    scratch for the smart routing byte
#    35  S1A   flag : smart routing equals 1
#    36  S1B   flag : smart routing equals 1 ; second consumer
#    37  B     ABI byte 8 : scoped request boundary verified
#    38  BT    scratch for the request boundary byte
#    39  B1A   flag : request boundary equals 1
#    40  B1B   flag : request boundary equals 1 ; second consumer
#    41  XB    ABI byte 9 : Pixel XL request boundary verified
#    42  XBT   scratch for the XL boundary byte
#    43  XB1   flag : XL request boundary equals 1
#    44  E     ABI byte 10 : editing capability
#    45  ET    scratch for the editing byte
#    46  E1    flag : editing capability equals 1 ; observed native
#    47  E2    flag : editing capability equals 2 ; verified override
#    48  OUT0  output byte 0 : upload identity policy
#    49  OUT1  output byte 1 : editing authorization
#
# COMMAND COUNT 3279 ; the BBC bounded frontend allows 3840
# SOURCE BYTES are far below the 65533 byte source limit
# NESTING is 2 levels ; the limit is 255
#
# Annotations are comments ; every byte outside the eight command
# characters is ignored by BBC and by the reference interpreters
#=====================================================================

# ====================================================================
# SECTION 1 : read the request and expand every byte into flags
# ====================================================================
# Each input byte is read once and immediately turned into equality
# flags in the cells next to it ; later tests then travel very little
    ,                                                          # read the version byte
    >[-]>[-]                                                   # V1 = version equals 1
    <<[->+>+<<]                                                # copy V to VT and park the restore value in V1
    >>[-<<+>>]                                                 # give the value back to V so V1 becomes zero again
    <->+                                                       # VT = V minus 1 ; then V1 starts at 1
    <[>[-]<[-]]                                                # a nonzero remainder clears V1 ; only equality survives
    >>>>,                                                      # read the operation byte
    >[-]>[-]                                                   # OP1 = operation equals 1
    <<[->+>+<<]                                                # copy OP to OPT and park the restore value in OP1
    >>[-<<+>>]                                                 # give the value back to OP so OP1 becomes zero again
    <->+                                                       # OPT = OP minus 1 ; then OP1 starts at 1
    <[>[-]<[-]]                                                # a nonzero remainder clears OP1 ; only equality survives
    [-]>>[-]                                                   # OP2 = operation equals 2
    <<<[->+>>+<<<]                                             # copy OP to OPT and park the restore value in OP2
    >>>[-<<<+>>>]                                              # give the value back to OP so OP2 becomes zero again
    <<-->>+                                                    # OPT = OP minus 2 ; then OP2 starts at 1
    <<[>>[-]<<[-]]                                             # a nonzero remainder clears OP2 ; only equality survives
    [-]>>>[-]                                                  # OP3 = operation equals 3
    <<<<[->+>>>+<<<<]                                          # copy OP to OPT and park the restore value in OP3
    >>>>[-<<<<+>>>>]                                           # give the value back to OP so OP3 becomes zero again
    <<<--->>>+                                                 # OPT = OP minus 3 ; then OP3 starts at 1
    <<<[>>>[-]<<<[-]]                                          # a nonzero remainder clears OP3 ; only equality survives
    [-]>>>>[-]                                                 # OP4 = operation equals 4
    <<<<<[->+>>>>+<<<<<]                                       # copy OP to OPT and park the restore value in OP4
    >>>>>[-<<<<<+>>>>>]                                        # give the value back to OP so OP4 becomes zero again
    <<<<---->>>>+                                              # OPT = OP minus 4 ; then OP4 starts at 1
    <<<<[>>>>[-]<<<<[-]]                                       # a nonzero remainder clears OP4 ; only equality survives
    >>>>>,                                                     # read the media class byte
    >[-]>[-]                                                   # MC1 = media class equals 1
    <<[->+>+<<]                                                # copy MC to MCT and park the restore value in MC1
    >>[-<<+>>]                                                 # give the value back to MC so MC1 becomes zero again
    <->+                                                       # MCT = MC minus 1 ; then MC1 starts at 1
    <[>[-]<[-]]                                                # a nonzero remainder clears MC1 ; only equality survives
    [-]>>[-]                                                   # MC2 = media class equals 2
    <<<[->+>>+<<<]                                             # copy MC to MCT and park the restore value in MC2
    >>>[-<<<+>>>]                                              # give the value back to MC so MC2 becomes zero again
    <<-->>+                                                    # MCT = MC minus 2 ; then MC2 starts at 1
    <<[>>[-]<<[-]]                                             # a nonzero remainder clears MC2 ; only equality survives
    [-]>>>[-]                                                  # MC3A = media class equals 3
    <<<<[->+>>>+<<<<]                                          # copy MC to MCT and park the restore value in MC3A
    >>>>[-<<<<+>>>>]                                           # give the value back to MC so MC3A becomes zero again
    <<<--->>>+                                                 # MCT = MC minus 3 ; then MC3A starts at 1
    <<<[>>>[-]<<<[-]]                                          # a nonzero remainder clears MC3A ; only equality survives
    >>>>>,                                                     # read the workflow state byte
    >[-]>[-]                                                   # WS1 = workflow equals 1
    <<[->+>+<<]                                                # copy WS to WST and park the restore value in WS1
    >>[-<<+>>]                                                 # give the value back to WS so WS1 becomes zero again
    <->+                                                       # WST = WS minus 1 ; then WS1 starts at 1
    <[>[-]<[-]]                                                # a nonzero remainder clears WS1 ; only equality survives
    [-]>>[-]                                                   # WS2 = workflow equals 2
    <<<[->+>>+<<<]                                             # copy WS to WST and park the restore value in WS2
    >>>[-<<<+>>>]                                              # give the value back to WS so WS2 becomes zero again
    <<-->>+                                                    # WST = WS minus 2 ; then WS2 starts at 1
    <<[>>[-]<<[-]]                                             # a nonzero remainder clears WS2 ; only equality survives
    [-]>>>[-]                                                  # WS3 = workflow equals 3
    <<<<[->+>>>+<<<<]                                          # copy WS to WST and park the restore value in WS3
    >>>>[-<<<<+>>>>]                                           # give the value back to WS so WS3 becomes zero again
    <<<--->>>+                                                 # WST = WS minus 3 ; then WS3 starts at 1
    <<<[>>>[-]<<<[-]]                                          # a nonzero remainder clears WS3 ; only equality survives
    >>>>,                                                      # read the capability byte
    >[-]>[-]                                                   # CAP1 = capability equals 1
    <<[->+>+<<]                                                # copy CAP to CAPT and park the restore value in CAP1
    >>[-<<+>>]                                                 # give the value back to CAP so CAP1 becomes zero again
    <->+                                                       # CAPT = CAP minus 1 ; then CAP1 starts at 1
    <[>[-]<[-]]                                                # a nonzero remainder clears CAP1 ; only equality survives
    [-]>>[-]                                                   # CAP2 = capability equals 2
    <<<[->+>>+<<<]                                             # copy CAP to CAPT and park the restore value in CAP2
    >>>[-<<<+>>>]                                              # give the value back to CAP so CAP2 becomes zero again
    <<-->>+                                                    # CAPT = CAP minus 2 ; then CAP2 starts at 1
    <<[>>[-]<<[-]]                                             # a nonzero remainder clears CAP2 ; only equality survives
    >>>,                                                       # read the master byte
    >[-]>[-]                                                   # M1 = master equals 1
    <<[->+>+<<]                                                # copy M to MT and park the restore value in M1
    >>[-<<+>>]                                                 # give the value back to M so M1 becomes zero again
    <->+                                                       # MT = M minus 1 ; then M1 starts at 1
    <[>[-]<[-]]                                                # a nonzero remainder clears M1 ; only equality survives
    >>>,                                                       # read the Pixel XL preference byte
    >[-]>[-]                                                   # X1 = Pixel XL preference equals 1
    <<[->+>+<<]                                                # copy X to XT and park the restore value in X1
    >>[-<<+>>]                                                 # give the value back to X so X1 becomes zero again
    <->+                                                       # XT = X minus 1 ; then X1 starts at 1
    <[>[-]<[-]]                                                # a nonzero remainder clears X1 ; only equality survives
    >>,                                                        # read the smart routing byte
    >[-]>[-]                                                   # S1A = smart routing equals 1
    <<[->+>+<<]                                                # copy S to ST and park the restore value in S1A
    >>[-<<+>>]                                                 # give the value back to S so S1A becomes zero again
    <->+                                                       # ST = S minus 1 ; then S1A starts at 1
    <[>[-]<[-]]                                                # a nonzero remainder clears S1A ; only equality survives
    >>>,                                                       # read the request boundary byte
    >[-]>[-]                                                   # B1A = request boundary equals 1
    <<[->+>+<<]                                                # copy B to BT and park the restore value in B1A
    >>[-<<+>>]                                                 # give the value back to B so B1A becomes zero again
    <->+                                                       # BT = B minus 1 ; then B1A starts at 1
    <[>[-]<[-]]                                                # a nonzero remainder clears B1A ; only equality survives
    >>>,                                                       # read the XL boundary byte
    >[-]>[-]                                                   # XB1 = XL request boundary equals 1
    <<[->+>+<<]                                                # copy XB to XBT and park the restore value in XB1
    >>[-<<+>>]                                                 # give the value back to XB so XB1 becomes zero again
    <->+                                                       # XBT = XB minus 1 ; then XB1 starts at 1
    <[>[-]<[-]]                                                # a nonzero remainder clears XB1 ; only equality survives
    >>,                                                        # read the editing byte
    >[-]>[-]                                                   # E1 = editing equals 1
    <<[->+>+<<]                                                # copy E to ET and park the restore value in E1
    >>[-<<+>>]                                                 # give the value back to E so E1 becomes zero again
    <->+                                                       # ET = E minus 1 ; then E1 starts at 1
    <[>[-]<[-]]                                                # a nonzero remainder clears E1 ; only equality survives
    [-]>>[-]                                                   # E2 = editing equals 2
    <<<[->+>>+<<<]                                             # copy E to ET and park the restore value in E2
    >>>[-<<<+>>>]                                              # give the value back to E so E2 becomes zero again
    <<-->>+                                                    # ET = E minus 2 ; then E2 starts at 1
    <<[>>[-]<<[-]]                                             # a nonzero remainder clears E2 ; only equality survives
# Nothing is read after the eleventh byte ; a longer request is
# truncated rather than trusted

# ====================================================================
# SECTION 2 : duplicate the flags that two rules consume
# ====================================================================
    <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<[-]<<[-]         # V1B = copy of V1 for the temporary gate
    >[->+<<+>]                                                 # copy V1 to V1B and keep V1
    <[->+<]                                                    # put the parked value back into V1
    >>>[-]<<<[-]                                               # V1C = copy of V1 for the editing gate
    >[->>+<<<+>]                                               # copy V1 to V1C and keep V1
    <[->+<]                                                    # put the parked value back into V1
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>[-]<<[-]                       # M1B = copy of M1 for the temporary gate
    >[->+<<+>]                                                 # copy M1 to M1B and keep M1
    <[->+<]                                                    # put the parked value back into M1
    <<<<<<<<<<<[-]<<<<[-]                                      # MC3B = copy of MC3A for the temporary gate
    >>>[->+<<<<+>>>]                                           # copy MC3A to MC3B and keep MC3A
    <<<[->>>+<<<]                                              # put the parked value back into MC3A
    >>>>>>>>>>>>>>>>>>>>>>>>[-]<<[-]                           # S1B = copy of S1A for the temporary gate
    >[->+<<+>]                                                 # copy S1A to S1B and keep S1A
    <[->+<]                                                    # put the parked value back into S1A
    >>>>>>[-]<<[-]                                             # B1B = copy of B1A for the temporary gate
    >[->+<<+>]                                                 # copy B1A to B1B and keep B1A
    <[->+<]                                                    # put the parked value back into B1A
# Copies are cheaper than a second equality test and cannot change
# meaning because the source cell is preserved

# ====================================================================
# SECTION 3 : backup gate ; T1 is the AND of four hard conditions
# ====================================================================
    <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<[->>>>>>>>>>>>>>>>>>>>>>>>>>[-<+>]<<<<<<<<<<<<<<<<<<<<<<<<<<]
    # MT = V1 AND M1
    >>>>>>>>>>>>>>>>>>>>>>>>>[->>>>>[-<+>]<<<<<]               # XT = MT AND X1
    >>>>[->>>>>>>>>>>>[-<+>]<<<<<<<<<<<<]                      # XBT = XT AND XB1 ; this is the T1 gate
# T1 is a 0 or 1 cell ; it stays in XBT until the last policy step

# ====================================================================
# SECTION 4 : policy byte ; the three backing up cases are exclusive
# ====================================================================
# Cases are selected by the operation byte ; they never overlap and
# their flags may simply be added into OUT0
    <<<<<<<<<<<<<<<<<<<<<<<<[->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>+<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<]
    # case A : ordinary backup
    >[->>>>>[-<+>]<<<<<]                                       # MCT = operation 2 AND media class 1
    >>>>[->>>>>>>[-<+>]<<<<<<<]                                # WST = MCT AND workflow 1
    >>>>>>[->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>+<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<]
    # case B : boost cover with validated metadata
    <<<<<<<<[->>>>>[-<<<+>>>]<<<<<]                            # MCT = operation 4 AND media class 3
    >>[->>>>>>>>>[-<<<+>>>]<<<<<<<<<]                          # WST = MCT AND workflow 3
    >>>>>>[->>>>>>>>>>>>>>>>>[-<+>]<<<<<<<<<<<<<<<<<]          # ST = WST AND smart routing
    >>>>>>>>>>>>>>>>[->>>>>[-<+>]<<<<<]                        # BT = ST AND request boundary
    >>>>[->>>>>>>>>>+<<<<<<<<<<]                               # case C : confirmed processed result
    >>>>>>>>>>[-<<<<<<[->>>+<<<]>>>>>>]                        # ET = OUT0 AND T1 ; apply the backup gate
    <<<[->>>+<<<]                                              # OUT0 now holds the backing up decision

# ====================================================================
# SECTION 5 : temporary job path ; policy 2 or 3 from capability
# ====================================================================
    <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<[->>>>>>>>>>>>>>>>>>>>>>>>>>[-<<+>>]<<<<<<<<<<<<<<<<<<<<<<<<<<]
    # MT = version AND master for the temporary gate
    >>>>>>>>>>>>>>>>>>>>>>>>[-<<<<<<<<<<<<<<<<<<[-<<<+>>>]>>>>>>>>>>>>>>>>>>]
    # OPT = MT AND operation 3
    <<<<<<<<<<<<<<<<<<<<<[->>>>>>>>>>>>>>[-<<+>>]<<<<<<<<<<<<<<]
    # WST = OPT AND workflow 2
    >>>>>>>>>>>>[->>>>>>>>>>>>>>>>>>[-<<+>>]<<<<<<<<<<<<<<<<<<]
    # ST = WST AND smart routing
    >>>>>>>>>>>>>>>>[->>>>>>[-<<+>>]<<<<<<]                    # BT = ST AND request boundary
# media class must be 2 or 3 and capability must be 1 or 2
    <<<<<<<<<<<<<<<<<<<<<<[-]>>>[-]                            # MCT = media class 2 flag
    <[-<<+>>>+<]                                               # copy MC2 to MCT and keep MC2
    >[-<+>]                                                    # put the parked value back into MC2
    >[-<<<<+>>>>]                                              # MCT = class 2 OR class 3
    >>>>>>>>>>>>>>>>>>>>>>[-<<<<<<<<<<<<<<<<<<<<<<<<<<[->>>+<<<]>>>>>>>>>>>>>>>>>>>>>>>>>>]
    # MC3A = temporary rule AND class is main
    <<<<<<<<<<<<<<<<<<<<[-]>>>>>[-]                            # WST = capability 1 flag
    >[-<<<<<<+>>>>>+>]                                         # copy CAP1 to WST and keep CAP1
    <[->+<]                                                    # put the parked value back into CAP1
    >>[-<<<<<<<+>>>>>>>]                                       # WST = capability 1 OR capability 2
    <<<<<<<<<<[->>>[->>>>>+<<<<<]<<<]                          # CAPT = full temporary rule match
# Translate the validated capability enum to the identity policy enum
# Capability one is native policy two and capability two is modern policy three
    >>>>>>>>[-<+[->>>>>>>>>>>>>>>>>>>>>>>>>>+<<<<<<<<<<<<<<<<<<<<<<<<<<]>]
    # if the temporary rule matched then move capability plus one into OUT0
# OUT0 cannot clash with the T1 term because the operation byte
# cannot be 3 and also 1 or 2 or 4

# ====================================================================
# SECTION 6 : editing byte ; independent of the upload identity
# ====================================================================
    >>>>>>>>>>>>>>>>>>>>>>>[-<+>]                              # ET = 1 when the editing byte is 1
    >[-<<++>>]                                                 # add 2 for every unit of the editing equals 2 flag
    <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<[->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>[->>>>+<<<<]<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<]
    # OUT1 = ET AND version equals 1
# An editing value outside 1 or 2 emits 0 and so does any request
# whose version byte is not exactly 1

# ====================================================================

# SECTION 6B : local backup eligibility only ; never an upload identity
# Operation five authorizes the version pinned offer check when version
# master Pixel XL preference and verified local boundary are all one
# Output four authorizes that check ; upload request gates are unchanged
    <<<<->[-]+<[>[-]<[-]]
    >>>>>----->[-]+<[>[-]<[-]]
    >>>>>>>>>>>>>>>>>>>>>->[-]+<[>[-]<[-]]
    >>>>->[-]+<[>[-]<[-]]
    >>>>>>>->[-]+<[>[-]<[-]]
    <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<[->>>>>[-<+>]<<<<<]
    >>>>[->>>>>>>>>>>>>>>>>>>>>>[-<+>]<<<<<<<<<<<<<<<<<<<<<<]
    >>>>>>>>>>>>>>>>>>>>>[->>>>>[-<+>]<<<<<]
    >>>>[->>>>>>>>[-<+>]<<<<<<<<]
    >>>>>>>[->>>>>>>>>>>++++<<<<<<<<<<<]<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# SECTION 7 : write the two output bytes
# ====================================================================
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.              # output byte 0 ; upload identity policy
    >.                                                         # output byte 1 ; editing authorization
# Every intermediate cell is left in a defined state and no further
# output is produced ; empty input reads as zeros and passes through
