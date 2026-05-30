# DevForge AI - Feature-First Folder Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── errors/
│   │   └── failure.dart
│   ├── network/
│   │   └── info.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── chat_service.dart
│   │   ├── progress_service.dart
│   │   ├── secure_storage_service.dart
│   │   ├── theme_service.dart
│   │   └── navigation_service.dart
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── string_utils.dart
│   │   └── file_utils.dart
│   ├── widgets/
│   │   ├── custom_app_bar.dart
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   ├── loading_indicator.dart
│   │   └── error_display.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── color_schemes.dart
│       └── typography.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login.dart
│   │   │       ├── logout.dart
│   │   │       ├── register.dart
│   │   │       └── check_auth_status.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   ├── biometric_auth_page.dart
│   │       │   └── register_page.dart
│   │       ├── widgets/
│   │       │   └── ...
│   │       └── providers/
│   │           └── auth_provider.dart
│   ├── home/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── home_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── repositories/
│   │   │   │   └── home_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_dashboard_stats.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── home_page.dart
│   │       ├── widgets/
│   │       │   └── ...
│   │       └── providers/
│   │           └── home_provider.dart
│   ├── chat/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── chat_model.dart
│   │   │   │   ├── message_model.dart
│   │   │   │   └── persona_model.dart
│   │   │   └── repositories/
│   │   │       ├── chat_repository_impl.dart
│   │   │       └── persona_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── repositories/
│   │   │   │   ├── chat_repository.dart
│   │   │   │   └── persona_repository.dart
│   │   │   └── usecases/
│   │   │       ├── send_message.dart
│   │   │       ├── get_chat_history.dart
│   │   │       ├── switch_persona.dart
│   │   │       └── clear_chat.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── chat_page.dart
│   │       ├── widgets/
│   │       │   ├── message_bubble.dart
│   │       │   ├── persona_switcher.dart
│   │       │   ├── chat_input_field.dart
│   │       │   └── code_display.dart
│   │       └── providers/
│   │           ├── chat_provider.dart
│   │           └── persona_provider.dart
│   ├── camera_scanner/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── scanner_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── repositories/
│   │   │   │   └── scanner_repository.dart
│   │   │   └── usecases/
│   │   │       ├── scan_code.dart
│   │   │       └── process_scanned_text.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── scanner_page.dart
│   │       ├── widgets/
│   │       │   ├── camera_preview.dart
│   │       │   └── scan_overlay.dart
│   │       └── providers/
│   │           └── scanner_provider.dart
│   ├── code_quality/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── quality_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── repositories/
│   │   │   │   └── quality_repository.dart
│   │   │   └── usecases/
│   │   │       ├── score_code.dart
│   │   │       └── get_improvement_suggestions.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── quality_scorer_page.dart
│   │       ├── widgets/
│   │       │   ├── score_display.dart
│   │       │   ├── progress_bars.dart
│   │       │   └── suggestion_list.dart
│   │       └── providers/
│   │           └── quality_provider.dart
│   ├── gamification/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── xp_model.dart
│   │   │   │   ├── level_model.dart
│   │   │   │   └── badge_model.dart
│   │   │   └── repositories/
│   │   │       └── gamification_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── repositories/
│   │   │   │   └── gamification_repository.dart
│   │   │   └── usecases/
│   │   │       ├── add_xp.dart
│   │   │       ├── check_level_up.dart
│   │   │       ├── award_badge.dart
│   │   │       └── get_daily_quest.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── gamification_dashboard.dart
│   │       │   └── quests_page.dart
│   │       ├── widgets/
│   │       │   ├── xp_display.dart
│   │       │   ├── level_progress.dart
│   │       │   └── badge_grid.dart
│   │       └── providers/
│   │           └── gamification_provider.dart
│   ├── hackathon_co_pilot/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── hackathon_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── repositories/
│   │   │   │   └── hackathon_repository.dart
│   │   │   └── usecases/
│   │   │       ├── generate_idea.dart
│   │   │       ├── get_tech_stack.dart
│   │   │       ├── create_folder_structure.dart
│   │   │       ├── generate_sample_code.dart
│   │   │       └── create_timeline.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── hackathon_co_pilot_page.dart
│   │       ├── widgets/
│   │       │   ├── idea_card.dart
│   │       │   ├── tech_stack_chips.dart
│   │       │   ├── folder_tree.dart
│   │       │   └── sample_code_viewer.dart
│   │       └── providers/
│   │           └── hackathon_provider.dart
│   ├── voice_io/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── voice_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── repositories/
│   │   │   │   └── voice_repository.dart
│   │   │   └── usecases/
│   │   │       ├── speech_to_text.dart
│   │   │       └── text_to_speech.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── voice_io_page.dart
│   │       ├── widgets/
│   │       │   ├── voice_button.dart
│   │       │   └── transcription_display.dart
│   │       └── providers/
│   │           └── voice_provider.dart
│   ├── skill_tracker/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── skill_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── repositories/
│   │   │   │   └── skill_repository.dart
│   │   │   └── usecases/
│   │   │       ├── add_skill.dart
│   │   │       ├── update_skill_level.dart
│   │   │       └── get_skill_radar.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── skill_tracker_page.dart
│   │       │   └── radar_chart_page.dart
│   │       ├── widgets/
│   │       │   ├── skill_chip.dart
│   │       │   ├── level_indicator.dart
│   │       │   └── radar_chart.dart
│   │       └── providers/
│   │           └── skill_provider.dart
│   ├── interview_prep/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── question_model.dart
│   │   │   │   └── answer_model.dart
│   │   │   └── repositories/
│   │   │       └── interview_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── repositories/
│   │   │   │   └── interview_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_question.dart
│   │   │       ├── evaluate_answer.dart
│   │   │       └── get_feedback.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── interview_prep_page.dart
│   │       │   └── mock_interview_page.dart
│   │       ├── widgets/
│   │       │   ├── question_card.dart
│   │       │   ├── answer_input.dart
│   │       │   └── feedback_display.dart
│   │       └── providers/
│   │           └── interview_provider.dart
│   ├── resume_analyzer/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── resume_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── repositories/
│   │   │   │   └── resume_repository.dart
│   │   │   └── usecases/
│   │   │       ├── analyze_resume.dart
│   │   │       └── get_suggestions.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── resume_analyzer_page.dart
│   │       ├── widgets/
│   │       │   ├── resume_input.dart
│   │       │   ├── score_display.dart
│   │       │   └── suggestion_list.dart
│   │       └── providers/
│   │           └── resume_provider.dart
│   └── snippet_library/
│       ├── data/
│       │   ├── models/
│       │   │   └── snippet_model.dart
│       │   └── repositories/
│       │       └── snippet_repository_impl.dart
│       ├── domain/
│       │   ├── repositories/
│       │   │   └── snippet_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_snippets.dart
│   │   │       ├── add_snippet.dart
│   │   │       ├── search_snippets.dart
│   │   │       └── favorite_snippet.dart
│       └── presentation/
│           ├── pages/
│           │   └── snippet_library_page.dart
│           ├── widgets/
│           │   ├── snippet_card.dart
│           │   ├── search_bar.dart
│           │   └── category_chips.dart
│           └── providers/
│               └── snippet_provider.dart
├── main.dart
└── routes.dart   # Or use go_router and define routes in each feature's presentation layer
```