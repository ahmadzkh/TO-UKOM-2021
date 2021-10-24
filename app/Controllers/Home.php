<?php

namespace App\Controllers;

class Home extends BaseController
{
    public function index()
    {
        $data = [
            'title' => 'UKOM | Dashboard Invent Apps'
        ];
        return view('dashboard/index', $data);
    }
}