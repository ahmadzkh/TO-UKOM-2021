<?php

namespace App\Controllers;

use App\Controllers\BaseController;
use \App\Models\UserModel;

/**
 * @author AhmadZakyHumami
 */
class UserController extends BaseController
{
    protected $userModel;
    
    public function __construct()
    {
        $this->userModel = new UserModel();
    }
    
    public function index()
    {
        $data = [
            'title' => 'UKOM | Users',
            'users' => $this->userModel->orderBy('level', 'ASC')->paginate(10, 'user'),
            'countUsers' => $this->userModel->countAll(),
            'pager' => $this->userModel->pager,
        ];

        // dd($data['users']);

        return view('pages/users/index', $data);
    }
}