<?php

class Controller_Sample extends Controller
{
    public function action_index()
    {
        $data['values'] = Model_Sample::get();
        return View::forge('sample/index', $data);
    }
}