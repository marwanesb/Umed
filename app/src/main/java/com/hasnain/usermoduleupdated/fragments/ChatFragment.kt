package com.hasnain.usermoduleupdated.fragments

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.lifecycleScope
import com.hasnain.usermoduleupdated.R
import com.hasnain.usermoduleupdated.databinding.FragmentChatBinding
import com.hasnain.usermoduleupdated.helper.ChatbotHelper
import kotlinx.coroutines.launch


class ChatFragment : Fragment() {
    private var _binding: FragmentChatBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentChatBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.submitButton.setOnClickListener {
            val prompt = binding.promptInput.text.toString()
            if (prompt.isNotEmpty()) {
                binding.responseText.text = "Loading..."
                lifecycleScope.launch {
                    val response = ChatbotHelper.getHealthGuidance(prompt)
                    binding.responseText.text = response
                }
            }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}