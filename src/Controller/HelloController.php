<?php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class HelloController extends AbstractController
{
    #[Route('/', name: 'app_hello')]
    public function index(): Response
    {
        return new Response('<h1>Hello from stage PFE @ OWLLABS :) LOGTARI MED LOUAY 2024/2025 ! </h1>');
    }
}
