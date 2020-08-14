;/**************************************************************************/
;/*                                                                        */
;/*       Copyright (c) Microsoft Corporation. All rights reserved.        */
;/*                                                                        */
;/*       This software is licensed under the Microsoft Software License   */
;/*       Terms for Microsoft Azure RTOS. Full text of the license can be  */
;/*       found in the LICENSE file at https://aka.ms/AzureRTOS_EULA       */
;/*       and in the root directory of this software.                      */
;/*                                                                        */
;/**************************************************************************/
;
;
;/**************************************************************************/
;/**************************************************************************/
;/**                                                                       */
;/** ThreadX Component                                                     */
;/**                                                                       */
;/**   Thread                                                              */
;/**                                                                       */
;/**************************************************************************/
;/**************************************************************************/
;
;
    SECTION `.text`:CODE:NOROOT(2)
    THUMB
;/**************************************************************************/
;/*                                                                        */
;/*  FUNCTION                                               RELEASE        */
;/*                                                                        */
;/*    _tx_thread_secure_stack_allocate                  Cortex-M33/IAR    */
;/*                                                           6.0.2        */
;/*  AUTHOR                                                                */
;/*                                                                        */
;/*    Scott Larson, Microsoft Corporation                                 */
;/*                                                                        */
;/*  DESCRIPTION                                                           */
;/*                                                                        */
;/*    This function enters the SVC handler to allocate a secure stack.    */
;/*                                                                        */
;/*  INPUT                                                                 */
;/*                                                                        */
;/*    thread_ptr                            Thread control block pointer  */
;/*    stack_size                            Size of secure stack to       */
;/*                                            allocate                    */
;/*                                                                        */
;/*  OUTPUT                                                                */
;/*                                                                        */
;/*    status                                Actual completion status      */
;/*                                                                        */
;/*  CALLS                                                                 */
;/*                                                                        */
;/*    SVC 1                                                               */
;/*                                                                        */
;/*  CALLED BY                                                             */
;/*                                                                        */
;/*    Application Code                                                    */
;/*                                                                        */
;/*  RELEASE HISTORY                                                       */
;/*                                                                        */
;/*    DATE              NAME                      DESCRIPTION             */
;/*                                                                        */
;/*  06-30-2020     Scott Larson             Initial Version 6.0.1         */
;/*  08-14-2020      Scott Larson            Modified comment(s), clean up */
;/*                                            whitespace, resulting       */
;/*                                            in version 6.0.2            */
;/*                                                                        */
;/**************************************************************************/
;UINT   _tx_thread_secure_stack_allocate(TX_THREAD *thread_ptr, ULONG stack_size)
;{
    EXPORT  _tx_thread_secure_stack_allocate
_tx_thread_secure_stack_allocate:
#if !defined(TX_SINGLE_MODE_SECURE) && !defined(TX_SINGLE_MODE_NON_SECURE)
    MRS     r3, PRIMASK     ; Save interrupt mask
    CPSIE   i               ; Enable interrupts for SVC call
    SVC     1
    CMP     r3, #0          ; If interrupts enabled, just return
    BEQ     _alloc_return_interrupt_enabled
    CPSID   i               ; Otherwise, disable interrupts
#else
    MOV32   r0, #0xFF       ; Feature not enabled
#endif
_alloc_return_interrupt_enabled
    BX      lr

    END
