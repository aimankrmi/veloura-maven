<%-- 
    Document   : seat-row
    Created on : 18 May 2025, 5:49:47 pm
    Author     : Aiman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>






<div class="row seat-row mx-4 flex-nowrap" data-seat="${param.seat}">
    <div class="col-1">
        <input type="checkbox" class="btn-check" name="seat" value="${param.seat}1" id="${param.seat}1" onclick="addSeat(this.id)" autocomplete="off" >
        <label class="btn seat-icon available" for="${param.seat}1">${param.seat}1</label>
    </div>
    <div class="col-1">
        <input type="checkbox" class="btn-check" name="seat" value="${param.seat}2" id="${param.seat}2"  onclick="addSeat(this.id)" autocomplete="off" >
        <label class="btn seat-icon available" for="${param.seat}2">${param.seat}2</label>
    </div>

    <!--aisle-->
    <div class="col-1">
    </div>

    <div class="col-1">
        <input type="checkbox" class="btn-check" name="seat" value="${param.seat}3" id="${param.seat}3" onclick="addSeat(this.id)" autocomplete="off" >
        <label class="btn seat-icon available" for="${param.seat}3">${param.seat}3</label>
    </div>

    <div class="col-1">
        <input type="checkbox" class="btn-check" name="seat" value="${param.seat}4" id="${param.seat}4" onclick="addSeat(this.id)" autocomplete="off" >
        <label class="btn seat-icon available" for="${param.seat}4">${param.seat}4</label>
    </div>

    <div class="col-1">
        <input type="checkbox" class="btn-check" name="seat" value="${param.seat}5" id="${param.seat}5" onclick="addSeat(this.id)" autocomplete="off" >
        <label class="btn seat-icon available" for="${param.seat}5">${param.seat}5</label>
    </div>

    <div class="col-1">
        <input type="checkbox" class="btn-check" name="seat" value="${param.seat}6" id="${param.seat}6" onclick="addSeat(this.id)" autocomplete="off" >
        <label class="btn seat-icon available" for="${param.seat}6">${param.seat}6</label>
    </div>

    <div class="col-1">
        <input type="checkbox" class="btn-check" name="seat" value="${param.seat}7" id="${param.seat}7" onclick="addSeat(this.id)" autocomplete="off" >
        <label class="btn seat-icon available" for="${param.seat}7">${param.seat}7</label>
    </div>

    <!--aisle-->
    <div class="col-1">
    </div>

    <div class="col-1">
        <input type="checkbox" class="btn-check" name="seat" value="${param.seat}8" id="${param.seat}8" onclick="addSeat(this.id)" autocomplete="off" >
        <label class="btn seat-icon available" for="${param.seat}8">${param.seat}8</label>
    </div>

    <div class="col-1">
        <input type="checkbox" class="btn-check" name="seat" value="${param.seat}9" id="${param.seat}9" onclick="addSeat(this.id)" autocomplete="off" >
        <label class="btn seat-icon available" for="${param.seat}9">${param.seat}9</label>
    </div>
<!--</div>-->
