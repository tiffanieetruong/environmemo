-- Clear everything people did during a session (users, unlocks, posts they made,
-- reactions, group walks) but keep the six starter spots and their starter posts.
delete from public.docs where coll in ('players','likes','checks','invites','groups','scans','friendreqs');
delete from public.docs where coll = 'posts'   and data->>'by' <> 'seed';
delete from public.docs where coll = 'replies' and data->>'by' <> 'seed';
delete from public.docs where coll = 'pins'    and data->>'by' <> 'seed';
