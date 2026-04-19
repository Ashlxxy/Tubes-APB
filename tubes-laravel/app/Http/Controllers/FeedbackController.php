<?php

namespace App\Http\Controllers;

use App\Models\Feedback;
use Illuminate\Http\Request;

class FeedbackController extends Controller
{
    public function index()
    {
        return view('feedback.index');
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'email' => 'required|email',
            'message' => 'required',
        ]);

        Feedback::create($request->all());

        return back()->with('success', 'Masukkan berhasil dikirim!');
    }

    public function adminIndex()
    {
        $feedbacks = Feedback::latest()->get();
        return view('admin.feedback', compact('feedbacks'));
    }
}
