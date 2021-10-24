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
        //
    }
}