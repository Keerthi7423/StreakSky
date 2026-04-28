// @ts-ignore
import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
// @ts-ignore
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.1";

// Suppress IDE Deno warnings
declare const Deno: any;

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: {
          headers: { Authorization: req.headers.get('Authorization')! },
        },
      }
    );

    const { habit_id, date, action } = await req.json();

    if (!habit_id || !date || !action) {
      throw new Error("Missing required parameters");
    }

    // Fetch current streak
    const { data: streak, error: streakError } = await supabaseClient
      .from('streaks')
      .select('*')
      .eq('habit_id', habit_id)
      .single();

    if (streakError && streakError.code !== 'PGRST116') {
      throw streakError;
    }

    let currentStreak = streak?.current_streak || 0;
    let longestStreak = streak?.longest_streak || 0;
    let shieldsHeld = streak?.shields_held || 0;
    let comebackCount = streak?.comeback_count || 0;
    
    // Simplistic Streak Logic (Fallback Edge Function)
    if (action === 'complete') {
        currentStreak += 1;
        if (currentStreak > longestStreak) {
            longestStreak = currentStreak;
        }
    } else if (action === 'uncomplete') {
        if (currentStreak > 0) {
            currentStreak -= 1;
        }
    } else if (action === 'missed') {
        if (shieldsHeld > 0) {
            shieldsHeld -= 1; // Use shield
        } else {
            if (currentStreak > 0) {
                // Track comeback if streak was broken
                comebackCount += 1;
            }
            currentStreak = 0;
        }
    }

    const { error: updateError } = await supabaseClient
      .from('streaks')
      .upsert({
        habit_id: habit_id,
        user_id: (await supabaseClient.auth.getUser()).data.user?.id,
        current_streak: currentStreak,
        longest_streak: longestStreak,
        last_active: date,
        shields_held: shieldsHeld,
        comeback_count: comebackCount,
        updated_at: new Date().toISOString()
      });

    if (updateError) throw updateError;

    return new Response(JSON.stringify({ 
        success: true, 
        currentStreak,
        longestStreak,
        shieldsHeld
    }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    });
  } catch (error: any) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    });
  }
});
