-- ==========================================
-- STREAKSKY INITIAL SCHEMA MIGRATION
-- DATE: 2026-04-22
-- ==========================================

-- 1. USERS TABLE
-- id matches Firebase Auth UID
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY,
    email TEXT,
    display_name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    subscription TEXT DEFAULT 'free',
    sub_expires_at TIMESTAMPTZ,
    timezone TEXT,
    language TEXT DEFAULT 'en'
);

-- 2. HABITS TABLE
CREATE TABLE IF NOT EXISTS public.habits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    emoji TEXT,
    color_hex TEXT,
    frequency JSONB DEFAULT '{"type": "daily"}',
    category TEXT,
    start_date DATE DEFAULT CURRENT_DATE,
    is_archived BOOLEAN DEFAULT FALSE,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. HABIT COMPLETIONS TABLE
CREATE TABLE IF NOT EXISTS public.habit_completions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    habit_id UUID NOT NULL REFERENCES public.habits(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    completed_date DATE NOT NULL,
    completed_at TIMESTAMPTZ DEFAULT NOW(),
    note TEXT,
    energy_level INTEGER CHECK (energy_level >= 1 AND energy_level <= 3),
    UNIQUE(habit_id, completed_date)
);

-- 4. STREAKS TABLE
CREATE TABLE IF NOT EXISTS public.streaks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    habit_id UUID NOT NULL REFERENCES public.habits(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    current_streak INTEGER DEFAULT 0,
    longest_streak INTEGER DEFAULT 0,
    last_active DATE,
    shields_held INTEGER DEFAULT 0 CHECK (shields_held >= 0 AND shields_held <= 3),
    comeback_count INTEGER DEFAULT 0,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(habit_id)
);

-- 5. GOALS TABLE (Weekly, Monthly, Career)
CREATE TABLE IF NOT EXISTS public.goals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('weekly', 'monthly', 'career')),
    title TEXT NOT NULL,
    description TEXT,
    target_value INTEGER,
    current_value INTEGER DEFAULT 0,
    start_date DATE,
    end_date DATE,
    linked_habits UUID[] DEFAULT '{}',
    phase INTEGER,
    is_completed BOOLEAN DEFAULT FALSE,
    rolled_over BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. QUOTES TABLE (Master curated list)
CREATE TABLE IF NOT EXISTS public.quotes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    text TEXT NOT NULL,
    author TEXT,
    author_year TEXT,
    category TEXT,
    weather_match TEXT[] DEFAULT '{}',
    milestone_match INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE
);

-- 7. USER QUOTES TABLE
CREATE TABLE IF NOT EXISTS public.user_quotes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    quote_id UUID REFERENCES public.quotes(id),
    saved_at TIMESTAMPTZ,
    shown_at TIMESTAMPTZ DEFAULT NOW(),
    was_shuffled BOOLEAN DEFAULT FALSE
);

-- 8. COMMIT MESSAGES TABLE (GitHub-style logic)
CREATE TABLE IF NOT EXISTS public.commit_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    message TEXT,
    weather_type TEXT,
    habits_done INTEGER,
    habits_total INTEGER,
    ai_generated BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, date)
);

-- 9. YEAR REVIEWS TABLE
CREATE TABLE IF NOT EXISTS public.year_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    year INTEGER NOT NULL,
    sunny_days INTEGER DEFAULT 0,
    stormy_days INTEGER DEFAULT 0,
    longest_streak INTEGER DEFAULT 0,
    top_habit_id UUID REFERENCES public.habits(id),
    goal_score INTEGER DEFAULT 0,
    ai_narrative TEXT,
    share_card_url TEXT,
    generated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, year)
);

-- ==========================================
-- ROW LEVEL SECURITY (RLS)
-- ==========================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE habits ENABLE ROW LEVEL SECURITY;
ALTER TABLE habit_completions ENABLE ROW LEVEL SECURITY;
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_quotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE commit_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE year_reviews ENABLE ROW LEVEL SECURITY;
-- quotes table is public read-only
ALTER TABLE quotes ENABLE ROW LEVEL SECURITY;

-- 1. USERS: User can only access their own profile
CREATE POLICY "Users can only view their own profile" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can only update their own profile" ON users FOR UPDATE USING (auth.uid() = id);

-- 2. HABITS: User can only access their own habits
CREATE POLICY "Users can access their own habits" ON habits FOR ALL USING (auth.uid() = user_id);

-- 3. HABIT COMPLETIONS: User can only access their own completions
CREATE POLICY "Users can access their own completions" ON habit_completions FOR ALL USING (auth.uid() = user_id);

-- 4. STREAKS: User can only access their own streaks
CREATE POLICY "Users can access their own streaks" ON streaks FOR ALL USING (auth.uid() = user_id);

-- 5. GOALS: User can only access their own goals
CREATE POLICY "Users can access their own goals" ON goals FOR ALL USING (auth.uid() = user_id);

-- 6. QUOTES: Public can view all quotes
CREATE POLICY "Everyone can view active quotes" ON quotes FOR SELECT USING (is_active = TRUE);

-- 7. USER QUOTES: User can only access their own quote logs
CREATE POLICY "Users can access their own quote logs" ON user_quotes FOR ALL USING (auth.uid() = user_id);

-- 8. COMMIT MESSAGES: User can only access their own messages
CREATE POLICY "Users can access their own messages" ON commit_messages FOR ALL USING (auth.uid() = user_id);

-- 9. YEAR REVIEWS: User can only access their own reviews
CREATE POLICY "Users can access their own reviews" ON year_reviews FOR ALL USING (auth.uid() = user_id);
